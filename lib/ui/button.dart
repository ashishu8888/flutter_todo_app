import 'package:flutter/material.dart';
import 'package:flutter_todo_app/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String? label;
  final Function? onTap;
  const MyButton({Key? key, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        child: Center(
          child: Text(
            label!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        width: 100,
        height: 60,
        decoration: BoxDecoration(
            color: primaryclr, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
