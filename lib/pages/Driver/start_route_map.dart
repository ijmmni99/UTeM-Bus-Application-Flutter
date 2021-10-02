import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:utem_bus_app/components/driver_locations_container.dart';
import 'package:utem_bus_app/components/map_pin_pill.dart';
import 'package:utem_bus_app/components/stop_button_driver_route.dart';
import 'package:utem_bus_app/models/location_pin.dart';
import 'package:utem_bus_app/models/map_styles.dart';
import 'package:utem_bus_app/models/pin_pill_info.dart';
import 'package:utem_bus_app/models/schedule_details.dart';
import 'package:utem_bus_app/shared/loading.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(2.3049, 102.3169);
const LatLng DEST_LOCATION = LatLng(2.3099, 102.3145);

class StartRouteMapDriver extends StatefulWidget {
  final List<Locations> locations;
  final Schedules schedules;
  final bool userStatus;

  const StartRouteMapDriver(
      {Key key, this.locations, this.userStatus, this.schedules})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => StartRouteMapDriverState();
}

class StartRouteMapDriverState extends State<StartRouteMapDriver> {
  StreamSubscription<LocationData> positionSubscription;
  StreamSubscription<DocumentSnapshot> firebaseSubcription;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinatesA = [];
  List<LatLng> polylineCoordinatesB = [];
  List<LatLng> polylineCoordinatesC = [];
  PolylinePoints polylinePoints;
  final String googleAPIKey = 'AIzaSyAPa6N5jxj2jRtQMEawssYBP_O8Azv3uVc';

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIconA;
  BitmapDescriptor destinationIconB;
  BitmapDescriptor destinationIconC;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfoA;
  PinInformation destinationPinInfoB;
  PinInformation destinationPinInfoC;
  bool locationApoly = false;
  bool locationBpoly = false;
  bool locationCpoly = false;
  bool isSetup = false;

  @override
  void initState() {
    super.initState();

    location = new Location();
    polylinePoints = PolylinePoints();

    setSourceAndDestinationIcons();
    setInitialLocation();
    initializeStatus();

    if (widget.userStatus == false) {
      firebaseSubcription = FirebaseFirestore.instance
          .collection('lokasisemasa')
          .doc(widget.locations[0].scheduleID)
          .snapshots()
          .listen((event) {
        currentLocation = LocationData.fromMap(
            {"latitude": event['latitude'], "longitude": event['longitude']});
        updatePinOnMap();
      });
    } else {
      positionSubscription =
          location.onLocationChanged.listen((LocationData cLoc) {
        currentLocation = cLoc;
        FirebaseFirestore.instance
            .collection('lokasisemasa')
            .doc(widget.locations[0].scheduleID)
            .set({
          "plateNumber": widget.schedules.plateNumber,
          "latitude": cLoc.latitude,
          "longitude": cLoc.longitude
        });
        updatePinOnMap();
      });
    }
  }

  void initializeStatus() async {
    if(widget.locations[0].locationStatus == 'In Schedule')
    await FirebaseFirestore.instance
        .collection('jadual')
        .doc(widget.locations[0].scheduleID)
        .update({'status': 'Ongoing'});
  }

  void setSourceAndDestinationIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/bus_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/blueMarker.png')
        .then((onValue) {
      destinationIconA = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/redMarker.png')
        .then((onValue) {
      destinationIconB = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/greenMarker.png')
        .then((onValue) {
      destinationIconC = onValue;
    });
  }

  void setInitialLocation() {
    if (widget.userStatus == false) {
      FirebaseFirestore.instance
          .collection('lokasisemasa')
          .doc(widget.locations[0].scheduleID)
          .get()
          .then((value) {
        currentLocation = LocationData.fromMap({
          "latitude": value.data()['latitude'],
          "longitude": value.data()['longitude']
        });
        setState(() {
          isSetup = true;
        });
      });
    } else {
      location.getLocation().then((value) {
        currentLocation = value;
        FirebaseFirestore.instance
            .collection('lokasisemasa')
            .doc(widget.locations[0].scheduleID)
            .set({
          "plateNumber": widget.schedules.plateNumber,
          "latitude": value.latitude,
          "longitude": value.longitude
        });

        setState(() {
          isSetup = true;
        });
      });
    }

    destinationLocation = LocationData.fromMap({
      "latitude": widget.locations[0].locationLatitude,
      "longitude": widget.locations[0].locationLongitude
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: widget.userStatus ? CAMERA_TILT : 0,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: widget.userStatus ? CAMERA_TILT : 0,
          bearing: CAMERA_BEARING);
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            isSetup
                ? GoogleMap(
                    myLocationEnabled: widget.userStatus ? true : false,
                    compassEnabled: true,
                    tiltGesturesEnabled: false,
                    markers: _markers,
                    polylines: _polylines,
                    mapType: MapType.normal,
                    initialCameraPosition: initialCameraPosition,
                    onTap: (LatLng loc) {
                      pinPillPosition = -100;
                    },
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(Utils.mapStyles).then((_) {
                        _controller.complete(controller);

                        if (_controller.isCompleted) {
                          showPinsOnMap();
                        }
                      });
                    })
                : Loading(),
            DriverLocationsRouteContainer(
              widget: widget,
              userstatus: widget.userStatus,
            ),
            StopButtonDriverRoute(
              widget: widget,
              userstatus: widget.userStatus,
            ),
            MapPinPillComponent(
                pinPillPosition: pinPillPosition,
                currentlySelectedPin: currentlySelectedPin)
          ],
        ),
      ),
    );
  }

  void showPinsOnMap() async {
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);

    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);

    var destPositionB = LatLng(widget.locations[1].locationLatitude,
        widget.locations[1].locationLongitude);

    var destPositionC = LatLng(widget.locations[2].locationLatitude,
        widget.locations[2].locationLongitude);

    sourcePinInfo = PinInformation(
        locationName: "Bus Location",
        location: SOURCE_LOCATION,
        pinPath: "assets/images/bus_pin.png",
        avatarPath: "assets/friend1.jpg",
        labelColor: Colors.blueAccent);

    destinationPinInfoA = PinInformation(
        locationName: widget.locations[0].locationName,
        location: destPosition,
        pinPath: "assets/images/blueMarker.png",
        avatarPath: "assets/friend2.jpg",
        labelColor: Colors.blue);

    destinationPinInfoB = PinInformation(
        locationName: widget.locations[1].locationName,
        location: destPositionB,
        pinPath: "assets/images/redMarker.png",
        avatarPath: "assets/friend2.jpg",
        labelColor: Colors.redAccent);

    destinationPinInfoC = PinInformation(
        locationName: widget.locations[2].locationName,
        location: destPositionC,
        pinPath: "assets/images/greenMarker.png",
        avatarPath: "assets/friend2.jpg",
        labelColor: Colors.green);

    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          if (mounted) {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          }
        },
        icon: sourceIcon));

    _markers.add(Marker(
        markerId: MarkerId('destPinA'),
        position: destPosition,
        onTap: () {
          if (mounted) {
            setState(() {
              currentlySelectedPin = destinationPinInfoA;
              pinPillPosition = 0;
            });
          }
        },
        icon: destinationIconA));

    _markers.add(Marker(
        markerId: MarkerId('destPinB'),
        position: destPositionB,
        onTap: () {
          if (mounted) {
            setState(() {
              currentlySelectedPin = destinationPinInfoB;
              pinPillPosition = 0;
            });
          }
        },
        icon: destinationIconB));

    _markers.add(Marker(
        markerId: MarkerId('destPinC'),
        position: destPositionC,
        onTap: () {
          if (mounted) {
            setState(() {
              currentlySelectedPin = destinationPinInfoC;
              pinPillPosition = 0;
            });
          }
        },
        icon: destinationIconC));

    setPolylines();
  }

  void setPolylines() async {

    print(widget.locations[0].locationStatus);
    if (widget.locations[0].locationStatus == 'Ongoing' ||
        widget.locations[0].locationStatus == 'Location A Delay') {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinatesA.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

      if (widget.locations[0].locationStatus == 'Location A' ||
          widget.locations[0].locationStatus == 'Location B Delay') {
            print('location driver : ' + currentLocation.latitude.toString() + ' , err');
        PolylineResult result2 =
            await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(
              currentLocation.latitude, currentLocation.longitude),
          PointLatLng(widget.locations[1].locationLatitude,
              widget.locations[1].locationLongitude),
        );

        if (result2.points.isNotEmpty)
          result2.points.forEach((PointLatLng point) {
            polylineCoordinatesB.add(LatLng(point.latitude, point.longitude));
          });
      }

      if (widget.locations[0].locationStatus == 'Location B' ||
          widget.locations[0].locationStatus == 'Location C Delay') {
        PolylineResult result3 =
            await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(currentLocation.latitude, currentLocation.longitude),
          PointLatLng(widget.locations[2].locationLatitude,
              widget.locations[2].locationLongitude),
        );

        if (result3.points.isNotEmpty)
          result3.points.forEach((PointLatLng point) {
            polylineCoordinatesC.add(LatLng(point.latitude, point.longitude));
          });
      }

      if (widget.locations[0].locationStatus == 'Location C') {
        _polylines.clear();
      }

      if (mounted) {
        setState(() {
          if (widget.locations[0].locationStatus == 'Ongoing' ||
              widget.locations[0].locationStatus == 'Location A Delay') {
            _polylines.clear();
            _polylines.add(Polyline(
                width: 3,
                polylineId: PolylineId("poly1"),
                color: Colors.blue,
                points: polylineCoordinatesA));
          }

          if (widget.locations[0].locationStatus == 'Location A' ||
              widget.locations[0].locationStatus == 'Location B Delay') {
            _polylines.clear();
            _polylines.add(Polyline(
                width: 3,
                polylineId: PolylineId("poly2"),
                color: Colors.redAccent,
                points: polylineCoordinatesB));
          }

          if (widget.locations[0].locationStatus == 'Location B' ||
              widget.locations[0].locationStatus == 'Location C Delay') {
            _polylines.clear();
            _polylines.add(Polyline(
                width: 3,
                polylineId: PolylineId("poly3"),
                color: Colors.green,
                points: polylineCoordinatesC));
          }

          if (widget.locations[0].locationStatus == 'Location C') {
            _polylines.clear();
          }
        });
      }
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: widget.userStatus ? CAMERA_TILT : 0,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    if ((widget.locations[0].locationStatus == 'Location A' ||
        widget.locations[0].locationStatus == 'Location B Delay' ) && locationApoly == false) {
      locationApoly = true;
      setPolylines();
    }

    if ((widget.locations[0].locationStatus == 'Location B' ||
        widget.locations[0].locationStatus == 'Location C Delay')  && locationBpoly == false ) {
      locationBpoly = true;
      _polylines.clear();
      setPolylines();
    }

    if (widget.locations[0].locationStatus == 'Location C') {
      _polylines.clear();
    }

    if (mounted) {
      setState(() {
        //update Location dlm firebase

        var pinPosition =
            LatLng(currentLocation.latitude, currentLocation.longitude);

        sourcePinInfo.location = pinPosition;

        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            onTap: () {
              setState(() {
                currentlySelectedPin = sourcePinInfo;
                pinPillPosition = 0;
              });
            },
            position: pinPosition,
            icon: sourceIcon));
      });
    }
  }

  @override
  void dispose() {
    positionSubscription?.cancel();
    firebaseSubcription?.cancel();
    super.dispose();
  }
}
