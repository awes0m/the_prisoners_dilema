import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.blue[800],
      scrolledUnderElevation: 4.0,
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.black54,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
