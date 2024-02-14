import 'package:compress_punk/constants.dart';
import 'package:flutter/material.dart';

class ChoiceChipWidget extends StatelessWidget {
  ChoiceChipWidget(
      {super.key,
      required this.title,
      required this.selected,
      this.onSelected});
  bool selected;
  String title;
  void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ChoiceChip(
        checkmarkColor: mainColor,
        backgroundColor: seconndaryColor,
        disabledColor: seconndaryColor,
        label: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        selectedColor: Colors.black,
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}
