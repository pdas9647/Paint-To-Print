import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';

class CustomBackdropToggleButton extends StatelessWidget {
  final AnimatedIconData icon;
  final Color color;

  const CustomBackdropToggleButton({
    Key key,
    this.icon = AnimatedIcons.close_menu,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: MediaQuery.of(context).size.width * 0.08,
      icon: AnimatedIcon(
        icon: icon,
        color: color,
        progress: Backdrop.of(context).animationController.view,
      ),
      onPressed: () => Backdrop.of(context).fling(),
    );
  }
}
