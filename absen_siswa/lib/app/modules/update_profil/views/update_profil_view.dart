import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profil_controller.dart';

class UpdateProfilView extends GetView<UpdateProfilController> {
  // const UpdateProfilView({Key? key}) : super(key: key);
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.namaC.text = user["nama"];
    controller.emailC.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PFROFIL'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            children: [
              // Image.asset('assets/a.png'),
              // Image.asset('../../../../assets/images/signup.png'),
              // <-- SEE HERE
            ],
          ),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.nipC,
            decoration:
                InputDecoration(labelText: "NIP", border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.namaC,
            decoration: InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Text(
          //   "Photo Profile",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     GetBuilder<UpdateProfilController>(
          //       builder: (c) {
          //         if (c.image != null) {
          //           return ClipOval(
          //             child: Container(
          //               height: 100,
          //               width: 100,
          //               child: Image.file(
          //                 File(c.image!.path),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           );
          //         } else {
          //           if (user["profile"] != null) {
          //             return ClipOval(
          //               child: Container(
          //                 height: 100,
          //                 width: 100,
          //                 child: Image.network(
          //                   user["profile"],
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //             );
          //           } else {
          //             return Text("No image choosen");
          //           }
          //         }
          //       },
          //     ),
          //     // user["profile"] != null && user["profil"] != ""
          //     //     ? Text("photo profil")
          //     //     : Text("no choosen"),
          //     TextButton(
          //       onPressed: () {
          //         controller.pickImage();
          //       },
          //       child: Text("choose"),
          //     )
          //   ],
          // ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                await controller.updateProfile(user['uid']);
              }
            },
            child: Text(controller.isLoading.isFalse
                ? "UPDATE PROFIL"
                : "LOADING. . ."),
          )
        ],
      ),
    );
  }
}
