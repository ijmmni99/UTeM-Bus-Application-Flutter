import 'package:flutter/material.dart';
import 'package:utem_bus_app/components/qr_code_preview.dart';
import 'package:utem_bus_app/pages/Driver/start_route_map.dart';

class StopButtonDriverRoute extends StatelessWidget {
  final StartRouteMapDriver widget;
  final bool userstatus;
  const StopButtonDriverRoute({
    Key key,
    this.widget,
    this.userstatus
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: userstatus? Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            height: size.height * 0.08,
            width: size.width * 0.3,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (BuildContext context) => QRCodePreview(scheduleID: widget.locations[0].scheduleID));
              },
              child: Center(
                child: Text(
                  'QR Code',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: size.height * 0.08,
            width: size.width * 0.3,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'STOP',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ) :Container(
            margin: EdgeInsets.all(20),
            height: size.height * 0.08,
            width: size.width * 0.3,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'STOP',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          )
      ,
    );
  }
}
