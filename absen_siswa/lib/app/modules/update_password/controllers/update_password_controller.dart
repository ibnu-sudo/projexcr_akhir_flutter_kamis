import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String emailUser = auth.currentUser!.email!;

        await auth.signInWithEmailAndPassword(
            email: emailUser, password: currC.text);
        await auth.currentUser!.updatePassword(newC.text);

        // await auth.signOut();
        print("BERHASIL UPDATE PASSWORD");

        Get.back();

        Get.snackbar("Berhasil", "Berhasil Update password");
      } on FirebaseAuthException catch (e) {
        if (e.code == "wrong-password") {
          Get.snackbar("Error", "Password yang dimasukan salah");
        } else {
          Get.snackbar("Error", "${e.code.toLowerCase()}");
        }
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat update password");
      } finally {
        isLoading.value = false;
      }
      if (newC.text == confirmC.text) {
      } else {
        Get.snackbar("Error", "Confirm password tidak cocok");
      }
    } else {
      Get.snackbar("Error", "Semua input harus di isi");
    }
  }
}
