// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utem_bus_app/components/qr_code_scanner.dart';
import 'package:utem_bus_app/pages/Driver/hubungi_driver.dart';
import 'package:utem_bus_app/pages/Driver/jadual_driver.dart';
import 'package:utem_bus_app/pages/Driver/laporan_driver.dart';
import 'package:utem_bus_app/pages/Student/favorite_schedule.dart';
import 'package:utem_bus_app/pages/Student/schedule.dart';
import 'package:utem_bus_app/pages/edit_profile.dart';
import 'package:utem_bus_app/shared/loading.dart';

class GridDashboard extends StatelessWidget {
  final DateTime dt = DateTime.now();
  final DateFormat newFormat = DateFormat("MMMMEEEEd");

  final bool userStatus;

  GridDashboard({
    Key key,
    this.userStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [];
    if (userStatus == true) {
      myList = [
        Items(
            title: "Jadual",
            subtitle: newFormat.format(dt),
            event: "",
            img: "assets/images/calendar.png",
            screen: DriverSchedule()),
        // Items(
        //     title: "Laporan",
        //     subtitle: "Akses Statistik",
        //     event: "",
        //     img: "assets/images/todo.png",
        //     screen: DriverReport()),
        // Items(
        //     title: "Map",
        //     subtitle: "Akses Lokasi Terkini",
        //     event: "",
        //     img: "assets/images/map.png",
        //     screen: DriverReport()),
        // Items(
        //     title: "Hubungi",
        //     subtitle: "Lapor Pihak PPKU",
        //     event: "",
        //     img: "assets/images/chat.png",
        //     screen: DriverReport()),
        Items(
            title: "Biodata",
            subtitle: "Lihat Biodata Anda",
            event: "",
            img: "assets/images/driver.png",
            screen: EditProfileWidget(userType: false,)),
      ];
    } else {
      myList = [
        Items(
            title: "Jadual",
            subtitle: newFormat.format(dt),
            event: "",
            img: "assets/images/calendar.png",
            screen: BusSchedule(userStatus: userStatus,)),
        Items(
            title: "Simpanan Jadual",
            subtitle: "Jadual yang Disimpan",
            event: "",
            img: "assets/images/todo.png",
            screen: FavorBusSchedule(userStatus: userStatus,)),
         Items(
            title: "Imbas QR Code",
            subtitle: "Imbas Bas QR Code",
            event: "",
            img: "assets/images/qr-code.png",
            screen: QRCodeScanner()),
        Items(
            title: "Biodata",
            subtitle: "Lihat Biodata Anda",
            event: "",
            img: "assets/images/driver.png",
            screen: EditProfileWidget(userType: true,)),
      ];
    }
    
    var color = Theme.of(context).primaryColor;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
              boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(8, 8),
                  blurRadius: 4.0)
              ],
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
              ),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  splashColor: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => data.screen));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          data.img,
                          width: 45,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(data.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(data.subtitle,
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 14,
                        ),
                        Text(data.event,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Widget screen;
  Items({this.title, this.subtitle, this.event, this.img, this.screen});
}
