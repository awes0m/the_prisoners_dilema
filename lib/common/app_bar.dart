import 'package:flutter/material.dart';
import 'package:the_prisoners_dilema/common/circular_app_icon.dart';

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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularAppIcon(size: 40),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: backgroundColor ?? Colors.blue[800],
      scrolledUnderElevation: 4.0,
      elevation: 4,
      shadowColor: Colors.black54,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
