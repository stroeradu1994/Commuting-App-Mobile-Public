import 'dart:async';
import 'dart:math';

import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/provider/trip_position_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_position_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:commuting_app_mobile/dto/direction/point.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassengerMap extends StatefulWidget {
  PassengerMapData t;

  PassengerMap(this.t);

  @override
  _PassengerMapState createState() => _PassengerMapState();
}

class _PassengerMapState extends State<PassengerMap> {
  LatLng? fromPoint;
  LatLng? toPoint;
  LatLng? driverPoint;

  Polyline? polyline;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;
  List<Marker> markers = [];

  late PassengerMapData t;

  Timer? timer;
  var _tripPositionService = locator.get<TripPositionService>();

  @override
  void initState() {
    super.initState();
    t = widget.t;
    if (t.withDriver) timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getDriverPosition());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
    return Column(
      children: [
        Expanded(child: _buildMap(context)),
        Container(
          height: 0,
          child: Column(),
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

    LatLng pickupPoint = fromLatLngString(t.pickupPoint!);
    LatLng dropPoint = fromLatLngString(t.dropPoint!);
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
    markers.add(new Marker(
      markerId: MarkerId('3'),
      infoWindow:
          InfoWindow(title: 'From', snippet: 'This is your drop position'),
      position: pickupPoint,
    ));
    markers.add(new Marker(
      markerId: MarkerId('4'),
      infoWindow:
          InfoWindow(title: 'To', snippet: 'This is your drop position'),
      position: dropPoint,
    ));
    if (driverPoint != null)
      markers.add(new Marker(
        markerId: MarkerId('5'),
        infoWindow: InfoWindow(title: 'Driver', snippet: 'Driver Position'),
        position: driverPoint!,
      ));
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

  Future getDriverPosition() async {
    Point? point = await _tripPositionService.get(t.tripId!, t.driverId!);
    if (point != null) {
      setState(() {
        driverPoint = new LatLng(point.lat!, point.lng!);
      });
    } else {
      timer?.cancel();
    }
  }
}

class PassengerMapData {
  String? tripId;
  String? driverId;
  Point? from;
  Point? to;
  String? pickupPoint;
  String? dropPoint;
  String? polyline;
  bool withDriver = false;

  PassengerMapData(this.tripId, this.driverId, this.from, this.to,
      this.pickupPoint, this.dropPoint, this.polyline, {this.withDriver = false});
}