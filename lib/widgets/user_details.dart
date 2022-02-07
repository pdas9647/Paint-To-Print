import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/models/user_model.dart';
import 'package:paint_to_print/screens/home_screen.dart';
import 'package:paint_to_print/widgets/loading_cube_grid.dart';

class UserDetails extends StatefulWidget {
  // static String routeName = '/userdetails';
  final double width;
  final double height;
  final UserModel userModel;
  const UserDetails({Key key, this.width, this.height, this.userModel})
      : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String getInitialLetter() {
    String initialLetter = '';
    if (widget.userModel.name.isNotEmpty) {
      initialLetter = widget.userModel.name.substring(0, 1);
    }
    return initialLetter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.38,
      width: widget.width * 0.94,
      // color: Colors.greenAccent,
      child: Card(
        elevation: 8.0,
        color: Colors.green.shade50,
        margin: EdgeInsets.symmetric(vertical: widget.height * 0.02),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.height * 0.05)),
        shadowColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(widget.width * 0.05),
              width: widget.width * 0.35,
              child: CircleAvatar(
                radius: widget.height * 0.10,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  getInitialLetter(),
                  style: GoogleFonts.arimo(
                    fontSize: MediaQuery.of(context).size.height * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: widget.width * 0.005),
            Container(
              width: widget.width * 0.55,
              // color: Colors.lightBlueAccent,
              padding: EdgeInsets.only(right: widget.width * 0.005),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// username
                  AutoSizeText(
                    widget.userModel.name,
                    maxLines: 1,
                    style: GoogleFonts.arimo(fontSize: widget.height * 0.05),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  /// email
                  AutoSizeText(
                    widget.userModel.email,
                    maxLines: 1,
                    style: GoogleFonts.arimo(fontSize: widget.height * 0.03),
                  ),

                  /// created at
                  AutoSizeText(
                    'Created At: ${widget.userModel.createdAt}',
                    maxLines: 1,
                    style: GoogleFonts.arimo(fontSize: widget.height * 0.03),
                  ),

                  /// no of docs
                  AutoSizeText(
                    'Documents ${widget.userModel.documentsCount}',
                    maxLines: 1,
                    style: GoogleFonts.arimo(fontSize: widget.height * 0.03),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
