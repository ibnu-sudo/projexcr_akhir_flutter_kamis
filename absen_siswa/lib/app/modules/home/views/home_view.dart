// import 'dart:html';

import 'package:absen_siswa/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import '../../../controllers/page_index_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  CollectionReference siswa = FirebaseFirestore.instance.collection("siswa");

  @override
  Widget build(BuildContext context) {
    Future<String> currentRole =
        siswa.doc(FirebaseAuth.instance.currentUser!.uid).get().then(
      (value) {
        var data = value.data() as Map<String, dynamic>;
        return data["role"];
      },
    );
    return FutureBuilder(
        future: currentRole,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data == "guru"
                // Scaffold ADMIN ###############################################################
                ? Scaffold(
                    appBar: AppBar(
                      title: const Text('HOME'),
                      centerTitle: true,
                      actions: [
                        IconButton(
                          onPressed: () => Get.toNamed(Routes.PROFILE),
                          icon: Icon(Icons.person),
                        ),
                        // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        //     stream: controller.streamGuru(),
                        //     builder: (context, snap) {
                        //       if (snap.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return SizedBox();
                        //       }
                        //       String role = snap.data!.data()!["role"];
                        //       if (role == "guru") {
                        //         //ini guru
                        //         return IconButton(
                        //           onPressed: () =>
                        //               Get.toNamed(Routes.ADD_SISWA),
                        //           // icon: Icon(Icons.person),
                        //         );
                        //       } else {
                        //         return SizedBox();
                        //       }
                        //     })
                      ],
                    ),
                    body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          Map<String, dynamic> user = snapshot.data!.data()!;

                          return ListView(
                            padding: EdgeInsets.all(20),
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.network(
                                        "https://ui-avatars.com/api/?name=${user['nama']}",
                                        // user["profile"] != null
                                        //     ? user["profile"] != ""
                                        //         ? user["profile"]
                                        //         : defaultImage
                                        //     : defaultImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Welcome",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          user["address"] != null
                                              ? "${user["address"]}"
                                              : "Belum ada lokasi",
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // height: 250,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user['job']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${user['nip']}",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "${user['nama']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // height: 250,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[200],
                                ),
                                child: StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamTodayPresence(),
                                  builder: (context, snapToday) {
                                    if (snapToday.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    Map<String, dynamic>? dataToday =
                                        snapToday.data?.data();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Masuk"),
                                            Text(dataToday?["masuk"] == null
                                                ? "-"
                                                : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                                          ],
                                        ),
                                        Container(
                                          width: 2,
                                          height: 40,
                                          color: Colors.black,
                                        ),
                                        Column(
                                          children: [
                                            Text("Keluar"),
                                            Text(dataToday?["keluar"] == null
                                                ? "-"
                                                : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "5 Hari yang lalu",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Get.toNamed(Routes.ALL_PRESENSI),
                                    child: Text("Daftar Riwayat"),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamLastPresence(),
                                  builder: (context, snapPresence) {
                                    if (snapPresence.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapPresence.data?.docs.length == 0 ||
                                        snapPresence.data == null) {
                                      return SizedBox(
                                        height: 150,
                                        child: Center(
                                          child: Text(
                                              "Belum ada daftar riwayat absensi"),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapPresence.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data = snapPresence
                                            .data!.docs[index]
                                            .data();
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Material(
                                            color: Colors.blue[400],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: InkWell(
                                              onTap: () => Get.toNamed(
                                                Routes.DETAIL_PRESENSI,
                                                arguments: data,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                // margin: EdgeInsets.only(bottom: 20),
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  // color: Colors.grey[200],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Masuk",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(data['masuk']
                                                                ?['date'] ==
                                                            null
                                                        ? "-"
                                                        : "${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Keluar",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(data['keluar']
                                                                ?['date'] ==
                                                            null
                                                        ? "-"
                                                        : "${DateFormat.jms().format(DateTime.parse(data['keluar']?['date']))}"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ],
                          );
                        } else {
                          return Center(
                              child: Text("Tidak dapat memuat database user."));
                        }
                      },
                    ),
                    bottomNavigationBar:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamGuru(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          Map<String, dynamic> user = snapshot.data!.data()!;
                          return SizedBox();
                          // return ConvexAppBar(
                          //   style: TabStyle.fixed,
                          //   items: [
                          //     TabItem(icon: Icons.home, title: 'Home'),

                          //     TabItem(icon: Icons.home, title: 'Home'),
                          //     // if (user["role"] == "siswa")
                          //     //   TabItem(
                          //     //       icon: Icons.fingerprint, title: 'absen'),
                          //     TabItem(icon: Icons.people, title: 'Profil'),
                          //   ],
                          //   initialActiveIndex: pageC.pageIndex.value,
                          //   onTap: (int i) => pageC.changePage(i),
                          // );
                        } else {
                          return Center(
                            child: Text("Tidak dapat memuat data user."),
                          );
                        }
                      },
                    ),
                  )
                // Scaffold(
                //     body: StreamBuilder(builder: (context, snap) {
                //       return Column(
                //         children: [
                //           Text("guru"),
                //           ElevatedButton(
                //               onPressed: () {
                //                 FirebaseAuth.instance.signOut();
                //                 Get.offAllNamed(Routes.LOGIN);
                //               },
                //               child: Text("Logout"))
                //         ],
                //       );
                //     }),
                //   )
                //Scaffold SISWA ################################################################
                : Scaffold(
                    appBar: AppBar(
                      title: const Text('HOME'),
                      centerTitle: true,
                      // actions: [
                      // IconButton(
                      //   onPressed: () => Get.toNamed(Routes.PROFILE),
                      //   icon: Icon(Icons.person),
                      // )
                      //   StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      //       stream: controller.streamRole(),
                      //       builder: (context, snap) {
                      //         if (snap.connectionState == ConnectionState.waiting) {
                      //           return SizedBox();
                      //         }
                      //         String role = snap.data!.data()!["role"];
                      //         if (role == "guru") {
                      //           //ini guru
                      //           return IconButton(
                      //             onPressed: () => Get.toNamed(Routes.ADD_SISWA),
                      //             icon: Icon(Icons.person),
                      //           );
                      //         } else {
                      //           return SizedBox();
                      //         }
                      //       })
                      // ],
                    ),
                    body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          Map<String, dynamic> user = snapshot.data!.data()!;

                          return ListView(
                            padding: EdgeInsets.all(20),
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.network(
                                        "https://ui-avatars.com/api/?name=${user['nama']}",
                                        // user["profile"] != null
                                        //     ? user["profile"] != ""
                                        //         ? user["profile"]
                                        //         : defaultImage
                                        //     : defaultImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Welcome",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          user["address"] != null
                                              ? "${user["address"]}"
                                              : "Belum ada lokasi",
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // height: 250,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user['job']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${user['nip']}",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "${user['nama']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // height: 250,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[200],
                                ),
                                child: StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamTodayPresence(),
                                  builder: (context, snapToday) {
                                    if (snapToday.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    Map<String, dynamic>? dataToday =
                                        snapToday.data?.data();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Masuk"),
                                            Text(dataToday?["masuk"] == null
                                                ? "-"
                                                : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                                          ],
                                        ),
                                        Container(
                                          width: 2,
                                          height: 40,
                                          color: Colors.black,
                                        ),
                                        Column(
                                          children: [
                                            Text("Keluar"),
                                            Text(dataToday?["keluar"] == null
                                                ? "-"
                                                : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Last 5 days",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Get.toNamed(Routes.ALL_PRESENSI),
                                    child: Text("Seen more"),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamLastPresence(),
                                  builder: (context, snapPresence) {
                                    if (snapPresence.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapPresence.data?.docs.length == 0 ||
                                        snapPresence.data == null) {
                                      return SizedBox(
                                        height: 150,
                                        child: Center(
                                          child: Text(
                                              "Belum ada history presensi"),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapPresence.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data = snapPresence
                                            .data!.docs[index]
                                            .data();
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Material(
                                            color: Colors.blue[400],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: InkWell(
                                              onTap: () => Get.toNamed(
                                                Routes.DETAIL_PRESENSI,
                                                arguments: data,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                // margin: EdgeInsets.only(bottom: 20),
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  // color: Colors.grey[200],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Masuk",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(data['masuk']
                                                                ?['date'] ==
                                                            null
                                                        ? "-"
                                                        : "${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Keluar",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(data['keluar']
                                                                ?['date'] ==
                                                            null
                                                        ? "-"
                                                        : "${DateFormat.jms().format(DateTime.parse(data['keluar']?['date']))}"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ],
                          );
                        } else {
                          return Center(
                              child: Text("Tidak dapat memuat database user."));
                        }
                      },
                    ),
                    bottomNavigationBar:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          Map<String, dynamic> user = snapshot.data!.data()!;
                          // return ElevatedButton(
                          //     onPressed: () {}, child: Icon(Icons.person));
                          return ConvexAppBar(
                            style: TabStyle.fixedCircle,
                            items: [
                              TabItem(icon: Icons.home, title: 'Home'),
                              if (user["role"] == "siswa")
                                TabItem(
                                    icon: Icons.fingerprint, title: 'absen'),
                              TabItem(icon: Icons.people, title: 'Profil'),
                            ],
                            initialActiveIndex: pageC.pageIndex.value,
                            onTap: (int i) => pageC.changePage(i),
                          );
                        } else {
                          return Center(
                            child: Text("Tidak dapat memuat data user."),
                          );
                        }
                      },
                    ),
                  );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
