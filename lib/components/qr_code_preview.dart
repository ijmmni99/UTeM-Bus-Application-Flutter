import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utem_bus_app/shared/loading.dart';


class QRCodePreview extends StatefulWidget {
  StreamSubscription<QuerySnapshot> firebaseSubcription;
  int totalStudent;
  int basCapacity;
  bool isMore = false;
  bool isLoading = true;
  final String scheduleID;
  QRCodePreview({
    Key key,
    this.scheduleID
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRCodePreviewState();

}

class QRCodePreviewState extends State<QRCodePreview> {
  
  @override
  void initState() {
    super.initState();
    widget.totalStudent = 0;

    initialBasCapacity();
    initialStudent();
  }

  void initialBasCapacity() async {
    await FirebaseFirestore.instance.collection('jadual').doc(widget.scheduleID).get().then((value) {
      FirebaseFirestore.instance.collection('bus').where('plateNumber', isEqualTo: value.data()['plateNumber'])
      .get().then((err) {
        setState(() {
            widget.basCapacity = err.docs.single.data()['capacity'];
        });
      });
    });
  }

  void initialStudent() async {
    widget.firebaseSubcription = FirebaseFirestore.instance
          .collection('ScheduleStudentHistory')
          .doc(widget.scheduleID)
          .collection('Students')
          .snapshots()
          .listen((event) {
            setState(() {
              widget.isLoading = false;
                widget.totalStudent = event.size;
                double halfBas = widget.basCapacity / 2;
                if(widget.totalStudent > halfBas)
                  widget.isMore = true;
                else
                  widget.isMore = false;
            });
          });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      
    title: Center(child: Text('QR Code')),
    content: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      widget.isLoading ? Loading() : Container(
        child: Text(
          'Jumlah Pelajar : ' + widget.totalStudent.toString(),
          style: widget.isMore ? TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold) : TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
       Container(
        child: Text(
          'Kapasiti Bas : ' + widget.basCapacity.toString(),
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),

      Container(
       width: 280, height: 280, 
       child: QrImage(
        data: widget.scheduleID,
        version: QrVersions.auto,
        size: 10.0,
    ),
     ),
    ],
      ),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  @override
  void dispose() {
    widget.firebaseSubcription?.cancel();
    super.dispose();
  }

  
}


