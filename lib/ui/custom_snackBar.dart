import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    key,
    content,
    required String message,
    String btnLabel = 'OK',
    Duration duration = const Duration(seconds: 1),
    VoidCallback? onOk,
  }) : super(
          key: key,
          content: Text(message),
          duration: duration,
          action: SnackBarAction(
              label: btnLabel,
              onPressed: () {
                if (onOk != null) {
                  onOk();
                }
              }),
        );
}
