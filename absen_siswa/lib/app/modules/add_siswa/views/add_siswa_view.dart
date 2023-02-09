import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_siswa_controller.dart';

class AddSiswaView extends GetView<AddSiswaController> {
  const AddSiswaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Siswa'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            children: [
              // Image.asset('assets/a.png'),
              Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/absen-admin-and-siswa.appspot.com/o/signup.png?alt=media&token=88b1d364-6982-4cc0-b83d-57ce30a6845a"),
              // <-- SEE HERE
            ],
          ),
          TextField(
            autocorrect: false,
            controller: controller.nipC,
            decoration:
                InputDecoration(labelText: "NIP", border: OutlineInputBorder()),
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
          TextField(
            autocorrect: false,
            controller: controller.jobC,
            decoration: InputDecoration(
              labelText: "Job",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              controller.addSiswa();
            },
            child: Text('Tambah Siswa'),
          )
        ],
      ),
    );
  }
}
