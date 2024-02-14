import 'package:compress_punk/constants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, this.onPressed, required this.title});

  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 140,
      child: MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            side: BorderSide(color: seconndaryColor, width: 2)),
        color: mainColor,
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(
              color: seconndaryColor,
            )),
      ),
    );
  }
}
