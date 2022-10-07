import 'package:flutter/material.dart';

class ShowModalButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color color;

  const ShowModalButton({
    required this.title,
    required this.onPressed,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
