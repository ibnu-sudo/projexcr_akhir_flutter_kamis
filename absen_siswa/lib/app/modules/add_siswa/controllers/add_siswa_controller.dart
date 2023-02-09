import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSiswaController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddSiswa() async {
    if (passAdminC.text.isNotEmpty) {
    } else {
      Get.snackbar("Error", "Password Harus diisi untuk keperluan Verifikasi");
    }
    try {
      String emailAdmin = auth.currentUser!.email!;

      UserCredential userCredentialAdmin =
          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passAdminC.text);

      UserCredential siswaCredential =
          await auth.createUserWithEmailAndPassword(
              email: emailC.text, password: "password");

      if (siswaCredential.user != null) {
        String uid = siswaCredential.user!.uid;

        await firestore.collection("siswa").doc(uid).set({
          "nip": nipC.text,
          "nama": namaC.text,
          "job": jobC.text,
          "email": emailC.text,
          "uid": uid,
          "role": "siswa",
          "createdAt": DateTime.now().toIso8601String(),
        });

        await siswaCredential.user!.sendEmailVerification();

        await auth.signOut();

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

        Get.back(); //menutup dialog
        Get.back(); // menutup dialog
        Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");

        // await auth.signInWithEmailAndPassword(email: email, password: password)
      }

      // print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
            "Terjadi kesalahan", "Password yang digunakan terlalu singkat");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Terjadi kesalahan",
            "Siswa sudah ada kamu anda tidak bisa menambahkan account/email yang sama");
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
            "Terjadi kesalahan", "Admin tidak dapat login. Password salah!");
      } else {
        Get.snackbar("Terjadi kesalahan", "${e.code}");
      }
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "Tidak dapat menambahkan Siswa");
    }
  }

  void addSiswa() async {
    if (namaC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Verifikasi Admin",
          content: Column(
            children: [
              Text("Masukan password untuk verifikasi admin !"),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                await prosesAddSiswa();
              },
              child: Text("Tambah Siswa"),
            ),
          ]);

      // try {
      //   UserCredential userCredential =
      //       await auth.createUserWithEmailAndPassword(
      //           email: emailC.text, password: "password");

      //   if (userCredential.user != null) {
      //     String uid = userCredential.user!.uid;

      //     await firestore.collection("siswa").doc(uid).set({
      //       "nip": nipC.text,
      //       "nama": namaC.text,
      //       "email": emailC.text,
      //       "uid": uid,
      //       "createdAt": DateTime.now().toIso8601String(),
      //     });

      //     await userCredential.user!.sendEmailVerification();

      //     await auth.signOut();

      //     // await auth.signInWithEmailAndPassword(email: email, password: password)
      //   }

      //   print(userCredential);
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     Get.snackbar(
      //         "Terjadi kesalahan", "Password yang digunakan terlalu singkat");
      //     print('The password provided is too weak.');
      //   } else if (e.code == 'email-already-in-use') {
      //     Get.snackbar("Terjadi kesalahan",
      //         "Siswa sudah ada kamu anda tidak bisa menambahkan account/email yang sama");
      //   }
      // } catch (e) {
      //   Get.snackbar("Terjadi kesalahan", "Tidak dapat menambahkan Siswa");
      // }
    } else {
      Get.snackbar("Terjadi kesalahan", "NIP, nama, Job dan email harus diisi");
    }
  }
}
