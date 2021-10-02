import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utem_bus_app/pages/Driver/driver_home_screen.dart';
import 'package:utem_bus_app/services/authentication_service.dart';
import 'package:utem_bus_app/shared/loading.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<bool>(
        future: context.read<AuthenticationService>().checkUser(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loading();
          default: 
          bool currentUserStatus;
          if (snapshot.data == false) {
            currentUserStatus = false;
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pelajar')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Loading();
                    default:
                      return DriverHomeScreen(data: snapshot.data, userStatus: currentUserStatus,);
                  }
                });
          } else {
            currentUserStatus = true;
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pemandu')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Loading();
                    default:
                      return DriverHomeScreen(data: snapshot.data, userStatus: currentUserStatus,);
                  }
                });
          }
          }
        }
      ),
    );
  }

  // @override
  // Widget build(BuildContext context){
  //   bool test = false;
  //   return Scaffold(
  //     backgroundColor: Colors.blue[50],
  //     body: StreamBuilder<DocumentSnapshot>(
  //       stream: context.read<AuthenticationService>().checkUser() ? FirebaseFirestore.instance.collection('pemandu').doc(FirebaseAuth.instance.currentUser.uid).snapshots() : FirebaseFirestore.instance.collection('pelajar').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
  //         if(snapshot.data.exists)
  //           if(snapshot.hasError)
  //             return Text('Error: ${snapshot.error}');

  //           switch(snapshot.connectionState) {
  //             case ConnectionState.waiting: return Loading();
  //             default:
  //               return DriverHomeScreen(data: snapshot.data);
  //           }
  //       },
  //     ),
  //   );
  // }
}
