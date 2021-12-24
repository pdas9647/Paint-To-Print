import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class PdfModel {
  String pdfName;
  List<Uint8List> canvasImages;
  String pdfCreationDate;
  Timestamp timestamp;

  PdfModel({
    this.pdfName,
    this.canvasImages,
    this.pdfCreationDate,
    this.timestamp,
  });
}
