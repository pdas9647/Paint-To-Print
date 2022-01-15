import 'package:flutter/material.dart';

class AboutUsSocialMediaIcon extends StatelessWidget {
  final IconData iconData;
  final String image;
  final Color color;
  final Function onTap;

  const AboutUsSocialMediaIcon({
    Key key,
    this.iconData,
    this.image,
    this.color = Colors.black,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: image != null
          ? Image.asset(
              image,
              fit: BoxFit.cover,
              height: 35.0,
              width: 35.0,
            )
          : IconButton(
              onPressed: () {},
              icon: Icon(iconData, size: 40.0, color: color),
            ),
    );
  }
}
