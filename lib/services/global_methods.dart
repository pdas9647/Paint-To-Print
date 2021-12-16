import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalMethods {
  static Future<void> customDialog(BuildContext context, String title,
      String subtitle, Function func) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Fira Sans',
                    color: Colors.redAccent,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Fira Sans',
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.getFont(
                  'Fira Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                func();
              },
              child: Text(
                'Delete',
                style: GoogleFonts.getFont(
                  'Fira Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> authErrorDialog(
      BuildContext context, String title, String subtitle) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Fira Sans',
                    color: Colors.redAccent,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Fira Sans',
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
                style: GoogleFonts.getFont(
                  'Fira Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> signOutDialog(BuildContext context, String title,
      String subtitle, Function func) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Fira Sans',
                    color: Colors.redAccent,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Fira Sans',
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                'No',
                style: GoogleFonts.getFont(
                  'Fira Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                func();
              },
              child: Text(
                'Yes',
                style: GoogleFonts.getFont(
                  'Fira Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
