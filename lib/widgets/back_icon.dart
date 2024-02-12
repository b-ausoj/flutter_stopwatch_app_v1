import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  final bool isBadgeVisible;

  const BackIcon(this.isBadgeVisible, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Badge(
            smallSize: 8.0,
            isLabelVisible: isBadgeVisible,
            child: const Icon(Icons.arrow_back)));
  }
}
