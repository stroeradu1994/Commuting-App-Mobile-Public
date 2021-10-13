import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'dart:async';
import 'dart:math';

import 'package:calendar_time/calendar_time.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:commuting_app_mobile/dto/trip/match_response.dart';
import 'package:commuting_app_mobile/dto/trip/trip_request_response_with_matches.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_passenger_trip.dart';
import 'package:commuting_app_mobile/services/location_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/match_service.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:commuting_app_mobile/dto/direction/point.dart';

class DriverMap extends StatefulWidget {
  DriverMapData t;

  DriverMap(this.t);

  @override
  _DriverMapState createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {

  LatLng? fromPoint;
  LatLng? toPoint;
  LatLng? passengerPoint;

  Polyline? polyline;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;
  List<Marker> markers = [];

  late DriverMapData t;

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    _getFromToPoints(context);
    buildMapContent();

    return MainScreen(
        hasBack: true,
        isList: false,
        child: _buildContent(context),
        header: AppLocalizations.of(context)!.tripMap);
  }

  _getFromToPoints(context) {
    fromPoint =
    new LatLng(t.from!.lat!, t.from!.lng!);
    toPoint = new LatLng(t.to!.lat!, t.to!.lng!);
  }

  Widget _buildContent(context) {
    return Stack(
      children: [
        _buildMap(context),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 160,
            child: Column(

            ),
          ),
        )
      ],
    );
  }

  Widget _buildMap(context) {
    return GoogleMap(
      mapType: MapType.normal,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
      cameraTargetBounds: new CameraTargetBounds(getBounds(markers)),
      initialCameraPosition: CameraPosition(
        target: fromPoint!,
        zoom: 14.4746,
      ),
      markers: Set<Marker>.of(markers),
      polylines: Set<Polyline>.of([polyline!]),
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        _mapController.complete(controller);
        CameraUpdate u2 = CameraUpdate.newLatLngBounds(getBounds(markers), 50);
        mapController!.animateCamera(u2);
      },
    );
  }

  buildMapContent() {
    _getPolyline(t.polyline!);
    markers.add(new Marker(
      markerId: MarkerId('1'),
      infoWindow: InfoWindow(title: 'From'),
      position: fromPoint!,
    ));
    markers.add(new Marker(
      markerId: MarkerId('2'),
      infoWindow:
      InfoWindow(title: 'To', snippet: 'This is your drop position'),
      position: toPoint!,
    ));
    if (passengerPoint != null) markers.add(new Marker(
      markerId: MarkerId('5'),
      infoWindow:
      InfoWindow(title: 'Driver', snippet: 'Passenger Position'),
      position: passengerPoint!,
    ));
    t.stops!.forEach((stop) {
      markers.add(new Marker(
        markerId: MarkerId('6'),
        infoWindow:
        InfoWindow(title: 'Driver', snippet: 'Passenger Position'),
        position: fromLatLngString(stop),
      ));
    });
  }

  fromLatLngString(String latlngString) {
    return new LatLng(double.parse(latlngString.split(',')[0].trim()),
        double.parse(latlngString.split(',')[1].trim()));
  }

  _getPolyline(String polyline) async {
    List<PointLatLng> result = polylinePoints.decodePolyline(polyline);
    this.polyline = Polyline(
        polylineId: PolylineId("poly"),
        width: 5,
        color: Colors.red,
        points:
        result.map((e) => new LatLng(e.latitude, e.longitude)).toList());
  }

  String durationToString(double seconds) {
    var d = Duration(minutes: seconds.toInt());
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}';
  }

  String metersToKm(double distance) {
    return (distance / 1000).toStringAsFixed(1);
  }

  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }
}

class DriverMapData {
  String? tripId;
  Point? from;
  Point? to;
  String? polyline;
  List<String>? stops;
  bool withPassenger  = false;

  DriverMapData(this.tripId, this.from, this.to, this.polyline, this.stops, {this.withPassenger = false});
}