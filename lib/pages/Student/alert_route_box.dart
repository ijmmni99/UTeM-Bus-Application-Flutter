import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utem_bus_app/models/location_pin.dart';
import 'package:utem_bus_app/models/schedule_details.dart';
import 'package:utem_bus_app/pages/Driver/start_route_map.dart';

class AlertRouteStudentBox extends StatefulWidget {
  final List<Locations> locations;
  final Schedules schedules;
  final bool userstatus;
  final bool favourite;

  const AlertRouteStudentBox(
      {Key key, this.userstatus, this.locations,this.favourite, this.schedules})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AlertRouteStudentBoxState();
}

class AlertRouteStudentBoxState extends State<AlertRouteStudentBox> {

  bool isStarted = true;

  @override
  void initState() {
    super.initState();
    checkStatus();
    setState(() {});
  }

  void checkStatus() {
      if(widget.schedules.locationStatus == 'In Schedule')
        isStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(child: Text('Maklumat Jadual Bas')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size.width * 0.7,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300],
                ),
                borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                          child: Image(
                        image: AssetImage('assets/images/bus.png'),
                        width: size.width * 0.2,
                      )),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('No. Plate: ' + widget.schedules.plateNumber),
                            SizedBox(
                              height: 3,
                            ),
                            Text('Status : ' + widget.schedules.locationStatus),
                            SizedBox(
                              height: 3,
                            ),
                            Text('Date : ' + widget.schedules.dates),
                            SizedBox(
                              height: 3,
                            ),
                          ])
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Center(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: widget.locations[0].locationName + ' ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      WidgetSpan(
                          child: Icon(
                        Icons.arrow_right_alt_rounded,
                        color: Colors.blueGrey,
                      )),
                      TextSpan(
                        text: ' ' + widget.locations[1].locationName + ' ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      WidgetSpan(
                          child: Icon(Icons.arrow_right_alt_rounded,
                              color: Colors.blueGrey)),
                      TextSpan(
                        text: ' ' + widget.locations[2].locationName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      )
                    ])),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                // child: isStarted ? Text(
                //   "DELAY",
                //   style: Theme.of(context)
                //       .textTheme
                //       .button
                //       .apply(color: Colors.white),
                // ) :
                child: widget.favourite ? Text(
                  "Delete",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ) : Text(
                  "Save",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ),
                //style: isStarted ? ElevatedButton.styleFrom(primary: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))) : ElevatedButton.styleFrom(primary: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  if(widget.favourite){
                    deleteFavorite();
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Jadual telah dipadam!'),
                      ),
                            );
                    });
                  }
                  else{
                  saveToFavorite();
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Jadual telah disimpan!'),
                  ),
                );
                  });
                  }
                  
                  
                }
              ),
              SizedBox(
                    width: 14,
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
                  "Track",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ),
                //style: isStarted ? ElevatedButton.styleFrom(primary: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))) : ElevatedButton.styleFrom(primary: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () => {
                  isStarted ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StartRouteMapDriver(
                              userStatus: widget.userstatus,
                              locations: widget.locations,
                            )))
                            :
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('The Schedule No Started Yet')))
                          
                }
              ),
              SizedBox(
                    width: 14,
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
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ),
                //style: isStarted ? ElevatedButton.styleFrom(primary: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))) : ElevatedButton.styleFrom(primary: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () => {
                  Navigator.pop(context)
                }
              )
                  ],)
                ],
              ),
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
    
  }

  void saveToFavorite() async {
   final firebaseUser = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('PersonalSchedule').doc(firebaseUser).collection('list').doc().set({
    'id' : firebaseUser,
    'scheduleID' : widget.schedules.scheduleID
    });
  }

  void deleteFavorite() async {
   final firebaseUser = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('PersonalSchedule').doc(firebaseUser).collection('list').where('scheduleID', isEqualTo: widget.schedules.scheduleID).get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }
}


