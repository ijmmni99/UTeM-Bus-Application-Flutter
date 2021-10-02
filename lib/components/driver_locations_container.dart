import 'package:flutter/material.dart';
import 'package:utem_bus_app/components/alert_route_status.dart';
import 'package:utem_bus_app/pages/Driver/start_route_map.dart';

class DriverLocationsRouteContainer extends StatelessWidget {
  const DriverLocationsRouteContainer({
    Key key,
    this.userstatus,
    @required this.widget,
  }) : super(key: key);
  final StartRouteMapDriver widget;
  final bool userstatus;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.all(30),
        child: Material(
          child: InkWell(
          splashColor: Colors.blue[50],
          highlightColor: Colors.blue[200],
            onTap: () {
             // ignore: unnecessary_statements
             userstatus ? showDialog(context: context, builder: (BuildContext context) => AlertRouteStatus(locations: widget.locations,)) :  null;
            },
            child: Ink(
              height: size.height * 0.08,
              width: size.width * 0.7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset.zero,
                        color: Colors.grey.withOpacity(0.5))
                  ]),
              child: Center(
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
            ),
          ),
        ),
      ),
    );
  }
}
