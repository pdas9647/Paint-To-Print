import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class PDFModel {
  String pdfName;
  List<Uint8List> canvasImages;
  String fileCreationDate;
  String pdfSize;
  String pdfUrl;
  int pdfPageCount;
  // String timestamp;
  String pdfLocation;

  PDFModel({
    this.pdfName,
    this.canvasImages,
    this.fileCreationDate,
    this.pdfSize,
    this.pdfUrl,
    this.pdfPageCount,
    // this.timestamp,
    this.pdfLocation,
  });

  factory PDFModel.fromDocument(QueryDocumentSnapshot queryDocumentSnapshot) {
    return PDFModel(
      pdfName: queryDocumentSnapshot.get('pdfName'),
      canvasImages: queryDocumentSnapshot.get('canvasImages'),
      fileCreationDate: queryDocumentSnapshot.get('fileCreationDate'),
      pdfSize: queryDocumentSnapshot.get('pdfSize'),
      pdfUrl: queryDocumentSnapshot.get('pdfUrl'),
      pdfPageCount: queryDocumentSnapshot.get('pdfPageCount'),
      // timestamp: queryDocumentSnapshot.get('timestamp'),
      pdfLocation: queryDocumentSnapshot.get('pdfLocation'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pdfName': pdfName,
      'canvasImages': canvasImages,
      'fileCreationDate': fileCreationDate,
      'pdfSize': pdfSize,
      'pdfUrl': pdfUrl,
      'pdfPageCount': pdfPageCount,
      // 'timestamp': timestamp,
      'pdfLocation': pdfLocation,
    };
  }
}
