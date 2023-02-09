import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ganti Password'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            // 1padding: EdgeInsets.all(20),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // children: [
                // Image.asset('assets/a.png'),
                child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/absen-admin-and-siswa.appspot.com/o/change.jpg?alt=media&token=ca80421b-19f6-4e75-87f2-48335d322ee6"),
                // <-- SEE HERE
                // ],
              ),
              TextField(
                controller: controller.newPassC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  controller.newPassword();
                },
                child: Text("LANJUTKAN"),
              )
            ],
          ),
        ));
  }
}
