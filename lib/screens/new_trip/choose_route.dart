import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:commuting_app_mobile/dto/direction/get_routes_request.dart';
import 'package:commuting_app_mobile/dto/direction/get_routes_result.dart';
import 'package:commuting_app_mobile/dto/direction/point.dart';
import 'package:commuting_app_mobile/provider/location_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/direction_service.dart';
import 'package:commuting_app_mobile/services/location_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/double_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ChooseRoute extends StatefulWidget {
  String leaveAt;

  ChooseRoute(this.leaveAt);

  @override
  _ChooseRouteState createState() => _ChooseRouteState();
}

class _ChooseRouteState extends State<ChooseRoute> {
  var creationService = locator.get<CreationService>();

  var locationService = locator.get<LocationService>();

  var directionService = locator.get<DirectionService>();

  bool fetched = false;

  List<GetRoutesResult>? routes;

  int currentIndex = 0;

  LatLng? fromPoint;

  LatLng? toPoint;

  Polyline? polyline;
  Set<Polyline> polylines = new Set();

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;

  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    if (!fetched) {
      _getFromToPoints(context);
      return FutureBuilder<List<GetRoutesResult>>(
          future: directionService.getRoutes(new GetRoutesRequest(
              from: new Point(
                  lat: fromPoint!.latitude, lng: fromPoint!.longitude),
              leaveAt: creationService.createTripDto!.leaveAt,
              to: new Point(lat: toPoint!.latitude, lng: toPoint!.longitude))),
          // a previously-obtained Future<String> or null
          builder: (BuildContext context,
              AsyncSnapshot<List<GetRoutesResult>> snapshot) {
            if (!snapshot.hasData) {
              return MainScreen(
                  hasBack: true,
                  isList: false,
                  child: Center(child: Text('Loading')),
                  header: AppLocalizations.of(context)!.chooseRoute);
            } else {
              fetched = true;
              routes = snapshot.data;
              return _buildContentWrapper(context);
            }
          });
    } else {
      return _buildContentWrapper(context);
    }
  }

  _getFromToPoints(context) {
    var locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    fromPoint = locationProvider.locations
        .where((element) => element.id == creationService.createTripDto!.from)
        .map((e) => new LatLng(e.point!.lat!, e.point!.lng!))
        .first;
    toPoint = locationProvider.locations
        .where((element) => element.id == creationService.createTripDto!.to)
        .map((e) => new LatLng(e.point!.lat!, e.point!.lng!))
        .first;
  }

  Widget _buildContentWrapper(context) {
    if (routes == null || routes!.isEmpty) {
      return MainScreen(
          hasBack: true,
          isList: false,
          child: Center(
              child: Text(AppLocalizations.of(context)!.noRouteSelected)),
          header: 'Choose Route');
    } else {
      buildMapContent();
      return MainScreen(
          hasBack: true,
          isList: false,
          child: _buildContent(context),
          header: AppLocalizations.of(context)!.chooseRoute);
    }
  }

  Widget _buildContent(context) {
    if (mapController != null) {
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(getBounds(markers), 50);
      mapController!.animateCamera(u2);
    }
    return Stack(
      children: [
        _buildMap(context),
        Positioned(
          bottom: 20,
          right: 0,
          left: 0,
          child: CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              scrollPhysics: BouncingScrollPhysics(),
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              onScrolled: (value) {
                if (value != null && value.round() != currentIndex) {
                  setState(() {
                    currentIndex = value.round();
                  });
                  CameraUpdate u2 =
                      CameraUpdate.newLatLngBounds(getBounds(markers), 50);
                  mapController!.animateCamera(u2);
                }
              },
            ),
            items: routes!
                .map((route) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        height: 160,
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                              AppLocalizations.of(context)!.arrive +
                                  TimeUtils.toCalendarTimeFromDateTime(
                                      DateTime.parse(widget.leaveAt).add(
                                          Duration(
                                              seconds:
                                                  route.duration!.toInt()))),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: textColor),
                            ))),
                            Expanded(
                                child: DoubleInfoWidget(
                              title1: Text(metersToKm(route.distance!) + ' km',
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: textColor)),
                              title2: Text(
                                  durationToString(route.duration!) + ' min',
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: textColor)),
                              subtitle1: Text(
                                  AppLocalizations.of(context)!.distance,
                                  style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: textColor)),
                              subtitle2: Text(
                                  AppLocalizations.of(context)!.duration,
                                  style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: textColor)),
                            )),
                            TextButton(
                                onPressed: () {
                                  creationService.createTripDto!.routeId =
                                      route.id;
                                  Navigator.pop(context);
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.chooseRoute,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)))
                          ],
                        ),
                      ),
                    ))
                .toList(),
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
        if (!_mapController.isCompleted) {
          _mapController.complete(controller);
          setState(() {});
        }
      },
    );
  }

  buildMapContent() {
    _getPolyline(routes![currentIndex].path!);
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
