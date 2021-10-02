import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QRCodeScanner extends StatefulWidget {

  final String scheduleID;
  const QRCodeScanner({
    Key key,
    this.scheduleID
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRCodeScannerState();

}

class QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'SCAN COMPLETED, You may Exit the QR scanner now')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void insertStudentInformation(String id) {
    String user = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
            .collection('ScheduleStudentHistory')
            .doc(id).collection('Students').doc(user).set({
              "studentID" : user
            });
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null)
        insertStudentInformation(result.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  
}


