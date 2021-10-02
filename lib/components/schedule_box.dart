// ignore: unused_import
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utem_bus_app/models/location_pin.dart';
import 'package:utem_bus_app/models/schedule_details.dart';
import 'package:utem_bus_app/pages/Driver/start_route_map.dart';
import 'package:utem_bus_app/pages/Student/alert_route_box.dart';

class TicketContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool userStatus;
  final bool favorite;
  const TicketContainer({Key key, this.data, this.userStatus, this.favorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locations> locations = [];
    DateFormat dateFormat = new DateFormat.Hm();
    DateFormat datefor =  DateFormat('yyyy-MM-dd');
    DateTime now = DateTime.now();
    Color colors;
   
    Schedules schedule = new Schedules(
      dates: data['tarikh'],
      driverID: data['driverID'],
      endTime: data['timeEnd'],
      locationStatus: data['status'],
      middleTime: data['timeMiddle'],
      plateNumber: data['plateNumber'],
      scheduleID: data['id'],
      startTime: data['timeStart']
    );

    DateTime open = dateFormat.parse(data['timeStart']);
    DateTime jam = dateFormat.parse(data['timeStart']);
    DateTime dateBetul = datefor.parse(data['tarikh']);
    dateBetul = new DateTime(dateBetul.year, dateBetul.month, dateBetul.day, open.hour, open.minute);
    open = new DateTime(dateBetul.year, dateBetul.month, dateBetul.day, open.hour, open.minute);
    DateTime close = dateFormat.parse(data['timeEnd']);
    close = new DateTime(now.year, now.month, now.day, close.hour, close.minute);
    jam = new DateTime(now.year, now.month, now.day, open.hour, open.minute);

    int dur = close.difference(jam).inMinutes;
    int departInInt = open.difference(now).inMinutes;
    Duration hmm = dateBetul.difference(now);

    String duration = dur.toString() + " min";
    String departIn = departInInt.toString();
    String minorhour = "min";

    //JIKA PEMANDU LEWAT
    // if(open.isBefore(now)){

    //   departIn = 'Due';
    //   minorhour = '';
    // }

    if (dur > 60) {
      dur = close.difference(jam).inHours;
      duration = dur.toString() + " hours";
    }

    if(dur < 60){
      dur = close.difference(jam).inMinutes;
      duration = dur.toString() + " minutes";
    }

    //if(departInInt > 60 && open.isAfter(now))
    if (departInInt > 60 || departInInt < 60) {
      departInInt = open.difference(now).inHours;
      departIn = departInInt.toString();
      minorhour = "hrs";

      if (departInInt == 0) {
        departInInt = open.difference(now).inMinutes;
        departIn = departInInt.toString();
        minorhour = "min";
      }
    }

    if(schedule.locationStatus != 'Finish' && schedule.locationStatus != 'In Schedule'){
      colors = Colors.green;
    }
    else {
      colors = Colors.grey[300];
    }

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: colors,
          ),
          borderRadius: BorderRadius.circular(25.0)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Departure In:"),
                    SizedBox(
                      height: 5.0,
                    ),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(minutes: 1)),
                      builder: (context, snapshot) {
                        now = DateTime.now();
                        int departInInt = open.difference(now).inMinutes;

                        departIn = hmm.inHours.toString();
                        minorhour = "hrs";

                        //if(departInInt > 60 && open.isAfter(now))
                        if (departInInt > 60 || departInInt < 60) {
                          departInInt = open.difference(now).inHours;
                          departIn =  hmm.inHours.toString();
                          minorhour = "hrs";

                          if (departInInt == 0) {
                            departInInt = open.difference(now).inMinutes;
                            departIn =  hmm.inMinutes.toString();
                            minorhour = "min";
                          }
                        }

                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: departIn,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              TextSpan(
                                  text: minorhour,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // userStatus ? RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(
                    //           text: "  Travel Time: ",
                    //           style: TextStyle(color: Colors.black87)),
                    //       TextSpan(
                    //           text: duration,
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.black87)),
                    //     ],
                    //   ),
                    // ) : 
                    Center(
                       child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: data['tarikh'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['timeStart'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: Colors.blueAccent,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 10.0),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 9),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['timeMiddle'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: Colors.redAccent,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 10.0),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 9),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['timeEnd'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: Colors.green,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 10.0),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    DateFormat('kk:mm').format(DateTime.now()),
                    style: TextStyle(color: Colors.blueAccent),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(.3),
                          border: Border.all(color: Colors.blue, width: 3.0),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('lokasi')
                            .doc(data['lokasiA'])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error: ${snapshot.error}");

                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text('Loading..');
                            default:
                              Locations lokasiA = new Locations(
                                  locationName:
                                      snapshot.data.data()['locationName'],
                                  scheduleID: data['id'],
                                  locationLatitude:
                                      snapshot.data.data()['latitude'],
                                  locationLongitude:
                                      snapshot.data.data()['longitude'],
                                  locationStatus: data['status']);

                              locations.add(lokasiA);

                              return Text(snapshot.data.data()['locationName'],
                                  style: TextStyle(color: Colors.black));
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(.3),
                          border:
                              Border.all(color: Colors.redAccent, width: 3.0),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('lokasi')
                            .doc(data['lokasiB'])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error: ${snapshot.error}");

                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text('Loading..');
                            default:
                              Locations lokasiB = new Locations(
                                  locationName:
                                      snapshot.data.data()['locationName'],
                                  scheduleID: data['id'],
                                  locationLatitude:
                                      snapshot.data.data()['latitude'],
                                  locationLongitude:
                                      snapshot.data.data()['longitude'],
                                  locationStatus: data['status']);

                              locations.add(lokasiB);
                              return Text(snapshot.data.data()['locationName'],
                                  style: TextStyle(color: Colors.black));
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(.3),
                          border: Border.all(color: Colors.green, width: 3.0),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('lokasi')
                            .doc(data['lokasiC'])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error: ${snapshot.error}");

                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text('Loading..');
                            default:
                              Locations lokasiC = new Locations(
                                  locationName:
                                      snapshot.data.data()['locationName'],
                                  scheduleID: data['id'],
                                  locationLatitude:
                                      snapshot.data.data()['latitude'],
                                  locationLongitude:
                                      snapshot.data.data()['longitude'],
                                  locationStatus: data['status']);

                              locations.add(lokasiC);
                              return Text(snapshot.data.data()['locationName'],
                                  style: TextStyle(color: Colors.black));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                // child: isStarted ? Text(
                //   "DELAY",
                //   style: Theme.of(context)
                //       .textTheme
                //       .button
                //       .apply(color: Colors.white),
                // ) :
                child: Text(
                  userStatus ? 
                  schedule.locationStatus == "Finish" ? "Finish":"START" : "SELECT",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ),
                //style: isStarted ? ElevatedButton.styleFrom(primary: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))) : ElevatedButton.styleFrom(primary: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () => userStatus ? schedule.locationStatus == "Finish" ? {} :  minorhour == "min" ?
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StartRouteMapDriver(
                              userStatus: userStatus,
                              locations: locations,
                              schedules: schedule,
                            ))) : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please wait until 59 min before departure time'))) :
                    showDialog(context: context, builder: (BuildContext context) => AlertRouteStudentBox(locations: locations,favourite: favorite,schedules: schedule, userstatus: userStatus,))
              )
            ],
          ),
        ],
      ),
    );
  }
}
