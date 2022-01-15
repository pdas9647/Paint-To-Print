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
    return Card(
      elevation: 10.0,
      // color: Colors.pink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.2))
      ),
      child: GestureDetector(
        onTap: onTap,
        child: image != null
            ? Image.asset(
                image,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.1,
              )
            : IconButton(
                onPressed: () {},
                icon: Icon(iconData, size: 40.0, color: color),
              ),
      ),
    );
  }
}
