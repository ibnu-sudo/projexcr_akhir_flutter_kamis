import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("BERHASIL",
            "Kami telah mengirimkan email reset password. Cek email mu!");
        Get.back();
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat mengirim email reset password");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
