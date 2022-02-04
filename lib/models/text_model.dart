import 'package:cloud_firestore/cloud_firestore.dart';

class TextModel {
  String textName;
  String fileCreationDate;
  String textSize;
  String textUrl;
  // String timestamp;
  String txtLocation;

  TextModel({
    this.textName,
    this.fileCreationDate,
    this.textSize,
    this.textUrl,
    // this.timestamp,
    this.txtLocation,
  });

  factory TextModel.fromDocument(QueryDocumentSnapshot queryDocumentSnapshot) {
    return TextModel(
      textName: queryDocumentSnapshot.get('textName'),
      fileCreationDate: queryDocumentSnapshot.get('fileCreationDate'),
      textSize: queryDocumentSnapshot.get('textSize'),
      textUrl: queryDocumentSnapshot.get('textUrl'),
      // timestamp: queryDocumentSnapshot.get('timestamp'),
      txtLocation: queryDocumentSnapshot.get('txtLocation'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'textName': textName,
      'fileCreationDate': fileCreationDate,
      'textSize': textSize,
      'textUrl': textUrl,
      // 'timestamp': timestamp,
      'txtLocation': txtLocation,
    };
  }
}
