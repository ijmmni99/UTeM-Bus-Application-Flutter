import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utem_bus_app/models/location_pin.dart';

class AlertRouteStatus extends StatefulWidget {
  final List<Locations> locations;

  const AlertRouteStatus({Key key, this.locations}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlertRouteStatusState();
}

class AlertRouteStatusState extends State<AlertRouteStatus> {
  bool locationAStatus = false;
  bool locationBStatus = false;
  bool locationCStatus = false;

  @override
  void initState() {
    super.initState();
    checkLocationStatus();

    setState(() {});
  }

  void checkLocationStatus() {
    if (widget.locations[0].locationStatus == 'Location A') {
      locationAStatus = true;
    }

    if (widget.locations[0].locationStatus == 'Location B') {
      locationAStatus = true;
      locationBStatus = true;
    }

    if (widget.locations[0].locationStatus == 'Location C') {
      locationAStatus = true;
      locationBStatus = true;
      locationCStatus = true;
    }

    if (widget.locations[0].locationStatus == 'Location A Delay') {
      locationAStatus = false;
    }

    if (widget.locations[0].locationStatus == 'Location B Delay') {
      locationAStatus = true;
      locationBStatus = false;
    }

    if (widget.locations[0].locationStatus == 'Location C Delay') {
      locationAStatus = true;
      locationBStatus = true;
      locationCStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(child: Text('Kemaskini Status')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size.width * 0.7,
            height: size.height * 0.15,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300],
                ),
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.locations[0].locationName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  ClipRect(
                    child: Container(
                      child: locationAStatus
                          ? Text('Arrived',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                TextButton.icon(
                                  onPressed: () => updateLocationStatus(widget.locations[0].scheduleID, false, 'A'),
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  label: Text(
                                    'Arrived',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => updateLocationStatus(widget.locations[0].scheduleID, true, 'A'),
                                  icon: Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delay',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            width: size.width * 0.7,
            height: size.height * 0.15,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300],
                ),
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.locations[1].locationName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ),
                  ClipRect(
                    child: Container(
                      child: locationBStatus
                          ? Text(
                              'Arrived',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                TextButton.icon(
                                  onPressed: () => updateLocationStatus(widget.locations[0].scheduleID, false, 'B'),
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  label: Text(
                                    'Arrived',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => updateLocationStatus(widget.locations[0].scheduleID, true, 'B'),
                                  icon: Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delay',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            width: size.width * 0.7,
            height: size.height * 0.15,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300],
                ),
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.locations[2].locationName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  ClipRect(
                    child: Container(
                      child: locationCStatus
                          ? Text(
                              'Arrived',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                TextButton.icon(
                                  onPressed: () => updateLocationStatus(widget.locations[0].scheduleID, false, 'C'),
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  label: Text(
                                    'Arrived',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => updateLocationStatus(widget.locations[0].scheduleID, true, 'C'),
                                  icon: Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delay',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  updateLocationStatus(String scheduleID, bool isLate, String locationPosition) async {
    if (isLate) {
      FirebaseFirestore.instance
            .collection('jadual')
            .doc(scheduleID)
            .update({"status": "Location " + locationPosition + " Delay"}).then((value) {
          widget.locations[0].locationStatus = 'Location ' + locationPosition + ' Delay';
          setState(() {
            print(locationAStatus);
          });
        });
    } else {
      if (locationPosition == 'A') {
        FirebaseFirestore.instance
            .collection('jadual')
            .doc(scheduleID)
            .update({"status": "Location A"}).then((value) {
          widget.locations[0].locationStatus = 'Location A';
          locationAStatus = true;
          setState(() {
            print(locationAStatus);
          });
        });
      } else if (locationPosition == 'B') {
        FirebaseFirestore.instance
            .collection('jadual')
            .doc(scheduleID)
            .update({"status": "Location B"}).then((value) {
          widget.locations[0].locationStatus = 'Location B';
          locationAStatus = true;
          locationBStatus = true;
          setState(() {});
        });
      } else {
        FirebaseFirestore.instance
            .collection('jadual')
            .doc(scheduleID)
            .update({"status": "Finish"}).then((value) {
          widget.locations[0].locationStatus = 'Finish';
          locationAStatus = true;
          locationBStatus = true;
          locationCStatus = true;
          setState(() {});
        });
      }
    }
  }
}
