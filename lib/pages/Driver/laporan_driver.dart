import 'package:flutter/material.dart';
import 'package:utem_bus_app/shared/loading.dart';

class DriverReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Loading(),
            SizedBox(
              height: 20.0,
            ),
            Text('Coming soon')
          ]),);
  }
}

