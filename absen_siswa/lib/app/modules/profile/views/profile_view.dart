import 'package:absen_siswa/app/controllers/page_index_controller.dart';
import 'package:absen_siswa/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () => Get.toNamed(Routes.HOME),
        //     icon: Icon(Icons.back_hand),
        //   ),
        // ],
      ),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamuser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            // String defaultImage =
            //     "https://ui-avatars.com/api/?name=${user['name']}";
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${user['nama'].toString().toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${user['email']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFIL, arguments: user),
                  leading: Icon(Icons.person),
                  title: Text("Update Profil"),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  leading: Icon(Icons.vpn_key),
                  title: Text("Update Password"),
                ),
                if (user["role"] == "guru")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_SISWA),
                    leading: Icon(Icons.person_add),
                    title: Text("Tambah siswa"),
                  ),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                )
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat data user."),
            );
          }
        },
      ),
      // bottomNavigationBar: ConvexAppBar(
      //   style: TabStyle.fixedCircle,
      //   items: [
      //     TabItem(icon: Icons.home, title: 'Home'),
      //     TabItem(icon: Icons.fingerprint, title: 'add'),
      //     TabItem(icon: Icons.people, title: 'Add'),
      //   ],
      //   initialActiveIndex: pageC.pageIndex.value,
      //   onTap: (int i) => pageC.changePage(i),
      // ),
    );
  }
}
