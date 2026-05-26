import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/check_button.dart';

class CheckButtonPopUp {
  static void showCheckButton(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(builder: (_) => const CheckButton());

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}