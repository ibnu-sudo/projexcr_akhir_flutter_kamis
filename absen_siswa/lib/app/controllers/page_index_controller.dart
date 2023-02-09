import 'package:absen_siswa/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        // print("ABSENSI");

        Map<String, dynamic> dataResponse = await _determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          String address =
              "${placemarks[0].name}, ${placemarks[0].subLocality},  ${placemarks[0].locality}";
          await updatePostion(
            position,
            address,
          );
          //cek distance between 2 position
          //mengatur lokasi jarak jangkauan absen
          double distance = Geolocator.distanceBetween(
            -6.1932084,
            106.5684342,
            position.latitude,
            position.longitude,
          );

          //presensi
          await presensi(position, address, distance);

          Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir");
          // Get.snackbar("${dataResponse['massage']}", address);

          // print("${position.latitude} , ${position.longitude}");
          // Get.snackbar("${dataResponse["massage"]}",
          //     "${position.latitude} , ${position.longitude}");
        } else {
          Get.snackbar("Error", dataResponse["massage"]);
        }
        break;

      case 2:
        pageIndex.value = i;
        Get.toNamed(Routes.PROFILE);

        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  //presensi

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("siswa").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    // print(snapPresence.docs.length);

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");
    // print(todayDocID);
    String status = "Diluar area";

    if (distance <= 200) {
      status = "Di dalam area";
    }

    if (snapPresence.docs.length == 0) {
      //belum pernah absen & set absen / pertama kali absen
      await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText: "Apakah kamu yakin akan mengisi daftar hadir sekrang?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("CANCEL")),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocID).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    },
                  });
                  Get.back();
                  Get.snackbar(
                      "Berhasil", "Kamu telah mengisi daftar hadir (MASUK)");
                },
                child: Text("YES"))
          ]);
    } else {
      //sudah pernah absen -> cek hari ini udah absen masuk/ keluar blm?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        //tinggal absen keluar atau sudah absen masuk & keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          //sudah absen masuk dan keluar
          Get.snackbar("Succes",
              "Kamu telah absen masuk & keluar, tidak dapat mengubah data kembali");
        } else {
          //absen keluar
          await Get.defaultDialog(
              title: "Validasi Presensi",
              middleText:
                  "Apakah kamu yakin akan mengisi daftar hadir (KELUAR)sekrang?",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("CANCEL")),
                ElevatedButton(
                    onPressed: () async {
                      await colPresence.doc(todayDocID).update({
                        "keluar": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        },
                      });
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Kamu telah mengisi daftar hadir (KELUAR)");
                    },
                    child: Text("YES"))
              ]);
        }
      } else {
        //absen masuk
        await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText:
                "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekrang?",
            actions: [
              OutlinedButton(
                  onPressed: () => Get.back(), child: Text("CANCEL")),
              ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocID).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      },
                    });

                    Get.back();
                    Get.snackbar(
                        "Berhasil", "Kamu telah mengisi daftar hadir (MASUK)");
                  },
                  child: Text("YES"))
            ]);

        // print("DIJALANKAN");

      }
    }
  }

  Future<void> updatePostion(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection("siswa").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "massage": "Tidak dapat mengambil GPS dari device ini",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "massage": "Izin akses GPS di tolak",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "massage":
            "Setting hp kamu tidak memperbolehan untuk mengakses GPS. Ubah settingan lokasi kamu",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return {
      "position": position,
      "massage": "Berhasil mendapatkan posisi anda",
      "error": false,
    };
  }
}
