import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/colors.dart';

void getSnackBar(String title, String message, bool error) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: error ? YColors.accent : YColors.primary,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    colorText: Colors.white,
  );
}
