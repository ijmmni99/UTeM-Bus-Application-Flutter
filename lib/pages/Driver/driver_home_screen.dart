import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/components/grid_dashboard.dart';
import 'package:utem_bus_app/services/authentication_service.dart';

import '../../components/grid_dashboard.dart';

class DriverHomeScreen extends StatelessWidget {
  final data;
  final bool userStatus;
  const DriverHomeScreen({
    Key key,
    this.userStatus,
    @required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(
          height: size.height * 0.1,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data['FirstName'],
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Dashboard",
                       style: TextStyle(
                         color: Color(0xffa29aac),
                         fontSize: 14,
                         fontWeight:FontWeight.w600
                        ),
                    )],
                ),
              // IconButton(
              //   alignment: Alignment.topCenter,
              //   icon: Icon(
              //     Icons.notifications
              //   ),
              //   onPressed: () {},
              // ),
               ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent, ),
                 icon: Icon(
                   Icons.logout,
                   color: Theme.of(context).primaryColor,
                 ),
                 label: Text('Log Keluar', style: TextStyle(color: Theme.of(context).primaryColor),),
                onPressed: () { context.read<AuthenticationService>().signOut();}, 
               )],
          ),
        ),
       GridDashboard(userStatus: userStatus,),
      ],
        
    );
  }
}