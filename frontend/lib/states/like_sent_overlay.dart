import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/like_sent.dart';


class LikedPopUp {
  static void showLikeSent(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(builder: (_) => const LikeSent());

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}