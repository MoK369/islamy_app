import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/widgets/toast_widget.dart';

abstract class Toasts {
  static void showErrorToast(String message) {
    getIt.get<FToast>().showToast(
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
        child: ToastWidget(
          text: message,
          color: Colors.red,
          icon: Icons.error_outline,
        ));
  }
}
