import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/components/schedule_box.dart';
import 'package:utem_bus_app/shared/loading.dart';

// ignore: must_be_immutable
class BusSchedule extends StatefulWidget {

  final DateTime dt = DateTime.now();
  final DateFormat newFormat = DateFormat.MMMMEEEEd();
  final DateFormat dateFormat =  DateFormat('yyyy-MM-dd');
  final bool userStatus;
  bool dataType;
  String _chosenValue;

  BusSchedule({
    Key key,
    this.userStatus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BusScheduleState();
}
  
class BusScheduleState extends State<BusSchedule> {

@override
  void initState() {
    widget.dataType = true;
    super.initState();
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
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        value: widget._chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white.withOpacity(.85),
                        items: <String>[
                          'Harian',
                          'Mingguan',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Filter",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.85),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            widget._chosenValue = value;
                          });
                          if (value == "Harian") {
                            setState(() {
                                widget.dataType = true;
                            });

                            } else if (value == 'Mingguan') {
                              setState(() {
                                  widget.dataType = false;
                              });

                          }
                        },
                      ),
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: widget.dataType ? FirebaseFirestore.instance.collection('jadual').where('tarikh', isEqualTo: widget.dateFormat.format(DateTime.now())).orderBy('timeStart', descending: false).snapshots() :
                        FirebaseFirestore.instance.collection('jadual').where('tarikh', isGreaterThanOrEqualTo: widget.dateFormat.format(_firstDayOfTheweek)).where('tarikh', isLessThanOrEqualTo: widget.dateFormat.format(_lastDayOfTheweek)).orderBy('tarikh', descending: false).snapshots() ,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error: ${snapshot.error}");

                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Loading();
                            default:
                              return ListView(
                                children: [
                                  if(snapshot.data.size < 1) Padding(padding: EdgeInsets.all(10.0),child: Center(child: Text('Tiada Jadual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),))),
                                  for (var item in snapshot.data.docs.where((element) => element.data()['anjal'] == '0700 - 1600'))
                                    TicketContainer(userStatus: widget.userStatus, favorite: false,
                                    data: item.data(),),
                                  if(snapshot.data.docs.where((element) => element.data()['anjal'] == '1600 - 1900').length > 0)  Padding(padding: EdgeInsets.all(10.0),child: Center(child: Text('Jadual Sebelah Petang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),))),
                                  for (var item in snapshot.data.docs.where((element) => element.data()['anjal'] == '1600 - 1900'))
                                    TicketContainer(userStatus: widget.userStatus, favorite: false,
                                    data: item.data(),)
                                ],
                              );
                          }
                        },
                      ),
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
