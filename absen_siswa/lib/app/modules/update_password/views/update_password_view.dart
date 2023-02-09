import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('UPDATE PASSWORD'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Image.network(
                "https://firebasestorage.googleapis.com/v0/b/absen-admin-and-siswa.appspot.com/o/change.jpg?alt=media&token=ca80421b-19f6-4e75-87f2-48335d322ee6"),
            TextField(
              controller: controller.currC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.newC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.confirmC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.updatePass();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse)
                      ? "CHANGE PASSWORD"
                      : "LOADING. . .",
                ),
              ),
            )
          ],
        ));
  }
}
