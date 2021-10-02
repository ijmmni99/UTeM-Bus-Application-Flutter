import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/components/schedule_box.dart';
import 'package:utem_bus_app/shared/loading.dart';

// ignore: must_be_immutable
class FavorBusSchedule extends StatefulWidget {

  final DateTime dt = DateTime.now();
  final DateFormat newFormat = DateFormat.MMMMEEEEd();
  final DateFormat dateFormat =  DateFormat('yyyy-MM-dd');
  final bool userStatus;
  bool dataType;
  bool loading = false;
  QuerySnapshot doc;
  String _chosenValue;
  List data;

  FavorBusSchedule({
    Key key,
    this.userStatus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FavorBusScheduleState();
}
  
class FavorBusScheduleState extends State<FavorBusSchedule> {

@override
  void initState() {
    widget.dataType = true;
    getFavorSchedule();
    super.initState();
  }

  void getFavorSchedule() async {
    widget.doc = await FirebaseFirestore.instance.collection('PersonalSchedule').doc(FirebaseAuth.instance.currentUser.uid).collection('list').get();
    widget.data = widget.doc.docs.map((doc) => doc.data()).toList();
    setState(() {
      widget.loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime today = DateTime.now();
    DateTime _firstDayOfTheweek = today.subtract(new Duration(days: today.weekday - 1));
    DateTime _lastDayOfTheweek = today.subtract(new Duration(days: today.weekday - 7));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget.newFormat.format(widget.dt),
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  Row(
                    children: <Widget>[
                      Text(
                        "Senarai Jadual",
                        style: TextStyle(
                            color: Colors.white.withOpacity(.79),
                            fontSize: 15.0),
                      ),
                      //DepartureSelector(),
                      Spacer(),
                      // ElevatedButton.icon(
                      //   style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                      //   onPressed: () {},
                      //   label: Text(
                      //     "Filters",
                      //     style:
                      //         TextStyle(color: Colors.white.withOpacity(.85)),
                      //   ),
                      //   icon: Icon(
                      //     Icons.settings,
                      //     color: Colors.white.withOpacity(.85),
                      //   ),
                      // )
                      
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -5),
                      blurRadius: 9,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    //MeansTransportMenu(),
                   Expanded(
                     child: widget.loading ? ListView.builder(
                       itemCount: widget.data.length,
                       itemBuilder: (context, index) {
                         return StreamBuilder<DocumentSnapshot>(
                           stream: FirebaseFirestore.instance.collection('jadual').doc(widget.data[index]['scheduleID']).snapshots(),
                           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                             if(snapshot.hasError)
                             return Text('Error : ${snapshot.error}');

                             switch (snapshot.connectionState){
                               case ConnectionState.waiting:
                               return Loading();
                               default:
                               return TicketContainer(userStatus: widget.userStatus, data: snapshot.data.data(),favorite: true,);
                             }
                             
                           },
                         );
                       }) : Loading(),
                      // child: StreamBuilder<QuerySnapshot>(
                      //   stream: widget.dataType ? FirebaseFirestore.instance.collection('jadual').where('tarikh', isEqualTo: widget.dateFormat.format(DateTime.now())).orderBy('timeStart', descending: false).snapshots() :
                      //   FirebaseFirestore.instance.collection('jadual').where('tarikh', isGreaterThanOrEqualTo: widget.dateFormat.format(_firstDayOfTheweek)).where('tarikh', isLessThanOrEqualTo: widget.dateFormat.format(_lastDayOfTheweek)).orderBy('tarikh', descending: false).snapshots() ,
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<QuerySnapshot> snapshot) {
                      //     if (snapshot.hasError)
                      //       return Text("Error: ${snapshot.error}");

                      //     switch (snapshot.connectionState) {
                      //       case ConnectionState.waiting:
                      //         return Loading();
                      //       default:
                      //         return ListView(
                      //           children: [
                      //             for (var item in snapshot.data.docs.where((element) => element.data()['anjal'] == '0700 - 1600'))
                      //               TicketContainer(userStatus: widget.userStatus,
                      //               data: item.data(),),
                      //             if(snapshot.data.docs.where((element) => element.data()['anjal'] == '1600 - 1900').length > 0)  Padding(padding: EdgeInsets.all(10.0),child: Center(child: Text('Jadual Sebelah Petang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),))),
                      //             for (var item in snapshot.data.docs.where((element) => element.data()['anjal'] == '1600 - 1900'))
                      //               TicketContainer(userStatus: widget.userStatus,
                      //               data: item.data(),)
                      //           ],
                      //         );
                      //     }
                      //   },
                      // ),
                    ),
                    Center(child: Text('Tekan "Select" Untuk Lihat Pergerakan Bas', style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).accentColor),),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
