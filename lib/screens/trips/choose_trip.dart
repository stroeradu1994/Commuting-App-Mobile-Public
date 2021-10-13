import 'dart:async';
import 'dart:math';

import 'package:calendar_time/calendar_time.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:commuting_app_mobile/dto/trip/match_response.dart';
import 'package:commuting_app_mobile/dto/trip/trip_request_response_with_matches.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_passenger_trip.dart';
import 'package:commuting_app_mobile/services/location_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/match_service.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChooseTrip extends StatefulWidget {
  TripRequestResponseWithMatches t;
  int currentIndex;

  ChooseTrip(this.t, this.currentIndex);

  @override
  _ChooseTripState createState() => _ChooseTripState();
}

class _ChooseTripState extends State<ChooseTrip> {
  var locationService = locator.get<LocationService>();

  bool fetched = false;

  int currentIndex = 0;

  LatLng? fromPoint;

  LatLng? toPoint;

  Polyline? polyline;

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  Completer<GoogleMapController> _mapController = Completer();

  GoogleMapController? mapController;
  List<Marker> markers = [];

  final CarouselController _controller = CarouselController();
  var tripRequestService = locator.get<TripRequestService>();
  var matchService = locator.get<MatchService>();

  TripRequestResponseWithMatches t = new TripRequestResponseWithMatches();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    t = widget.t;
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    _getFromToPoints(context);
    buildMapContent();

    return MainScreen(
        hasBack: true,
        isList: false,
        child: _buildContent(context),
        header: AppLocalizations.of(context)!.chooseTrip);
  }

  _getFromToPoints(context) {
    fromPoint =
        new LatLng(t.fromLocation!.point!.lat!, t.fromLocation!.point!.lng!);
    toPoint = new LatLng(t.toLocation!.point!.lat!, t.toLocation!.point!.lng!);
  }

  Widget _buildContent(context) {
    var upcomingTripsProvider =
        Provider.of<UpcomingTripsProvider>(context, listen: false);
    var tripRequestsProvider =
        Provider.of<TripRequestsProvider>(context, listen: false);

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
              aspectRatio: 3.0,
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
            items: t.matches!
                .map((match) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                    AppLocalizations.of(context)!.walking +
                                        ' ' +
                                        metersToKm(
                                            match.pickupWalkingDistance! +
                                                match.dropWalkingDistance!) +
                                        ' km',
                                    style: TextStyle(
                                        fontSize: 13, color: textColor)),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.leaving +
                                      TimeUtils.toCalendarTimeFromString(
                                          match.leaveTime!.toString()),
                                  style:
                                      TextStyle(fontSize: 13, color: textColor),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.arriving +
                                      TimeUtils.toCalendarTimeFromString(
                                          match.arriveTime!.toString()),
                                  style:
                                      TextStyle(fontSize: 13, color: textColor),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await matchService.match(match.matchId!);

                                  await upcomingTripsProvider
                                      .getUpcomingTrips();
                                  await tripRequestsProvider.getTripRequests();

                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            UpcomingPassengerTrip(
                                                match.tripId!)),
                                  );
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.chooseTrip,
                                    style: TextStyle(
                                        color: textColor,
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
        _mapController.complete(controller);
        CameraUpdate u2 = CameraUpdate.newLatLngBounds(getBounds(markers), 50);
        mapController!.animateCamera(u2);
      },
    );
  }

  buildMapContent() {
    MatchResponse currentMatchResponse = t.matches![currentIndex];
    LatLng pickupPoint = fromLatLngString(currentMatchResponse.pickupPoint!);
    LatLng dropPoint = fromLatLngString(currentMatchResponse.dropPoint!);
    _getPolyline(currentMatchResponse.polyline!);
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
      markerId: MarkerId('2'),
      infoWindow:
          InfoWindow(title: 'From', snippet: 'This is your drop position'),
      position: pickupPoint,
    ));
    markers.add(new Marker(
      markerId: MarkerId('2'),
      infoWindow:
          InfoWindow(title: 'To', snippet: 'This is your drop position'),
      position: dropPoint,
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
