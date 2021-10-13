import 'dart:async';

import 'package:commuting_app_mobile/dto/location/create_location_request.dart';
import 'package:commuting_app_mobile/dto/location/location_dto.dart';
import 'package:commuting_app_mobile/dto/location/location_label.dart';
import 'package:commuting_app_mobile/provider/location_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/services/location_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart' as geoc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'address_search.dart';

class EditLocation extends StatefulWidget {
  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  var locationService = locator.get<LocationService>();

  Future<List<LocationDto>>? locations;

  String? selectedLabel;

  Marker marker = new Marker(
    markerId: new MarkerId("1"),
  );
  bool locationRetrieved = false;

  LatLng? latLng;

  List<String> customLabels = [];

  Completer<GoogleMapController> _mapController = Completer();
  final _searchController = TextEditingController();
  final TextEditingController _newLabelTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationRetrieved) {
      getInitialLocation();
      return MainScreen(
          hasBack: true,
          isList: false,
          child: Center(child: Text('Loading')),
          header: AppLocalizations.of(context)!.newLocation);
    } else {
      return MainScreen(
          hasBack: true,
          isList: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _buildMap(),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _buildForm(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCreateLocationButton(),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          header: AppLocalizations.of(context)!.newLocation);
    }
  }

  Widget _buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      padding: EdgeInsets.only(bottom: 80),
      initialCameraPosition: CameraPosition(
        target: latLng!,
        zoom: 16.4746,
      ),
      zoomControlsEnabled: false,
      markers: [marker].toSet(),
      onCameraMove: (_position) => updateLatLng(_position),
      onCameraIdle: () => _updatePosition(),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Widget _buildForm() {
    List<String> labels = [
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.work,
      AppLocalizations.of(context)!.school
    ];

    if (selectedLabel == null) selectedLabel = labels[0];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 14),
              readOnly: true,
              onTap: () async {
                final sessionToken = Uuid().v4();
                final result = await showSearch(
                  context: context,
                  delegate: AddressSearch(sessionToken),
                );
                if (result != null) {
                  final query = result.description;
                  var addresses = await geoc.locationFromAddress(query);
                  var first = addresses.first;

                  GoogleMapController ctrl = await _mapController.future;
                  setState(() {
                    _searchController.text = result.description;
                    latLng = new LatLng(first.latitude, first.longitude);
                    ctrl.moveCamera(CameraUpdate.newLatLng(
                        new LatLng(first.latitude, first.longitude)));
                    marker = marker.copyWith(
                        positionParam:
                            new LatLng(first.latitude, first.longitude));
                  });
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.pin_drop, color: primaryColor),
                hintStyle: TextStyle(fontSize: 10),
                hintText: "Search address",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 40,
            // padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 8);
              },
              itemCount: labels.length + customLabels.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == labels.length + customLabels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildNewCustomLabel(),
                  );
                } else {
                  if (index < labels.length) {
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(left: 16.0)
                          : EdgeInsets.zero,
                      child: _buildLabelChoiceChip(labels[index]),
                    );
                  } else {
                    return _buildLabelChoiceChip(
                        customLabels[index - labels.length]);
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

  ChoiceChip _buildLabelChoiceChip(String label) {
    bool isSelected = selectedLabel == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      onSelected: (value) {
        setState(() {
          selectedLabel = label;
        });
      },
      selectedColor: primaryColor,
      selected: selectedLabel == label,
    );
  }

  ElevatedButton _buildCreateLocationButton() {
    var locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
        onPressed: () async {
          CreateLocationRequest createLocationRequest =
              new CreateLocationRequest(
                  address: _searchController.text,
                  label: selectedLabel,
                  lat: latLng!.latitude,
                  lng: latLng!.longitude);

          await locationService.saveLocation(createLocationRequest);
          await locationProvider.getLocations();

          Navigator.pop(context);
        },
        child: Text(AppLocalizations.of(context)!.createLocation, style: TextStyle(color: Colors.white)));
  }

  getInitialLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData locationData = await location.getLocation();
    setState(() {
      latLng = new LatLng(locationData.latitude!, locationData.longitude!);
      locationRetrieved = true;
      marker = marker.copyWith(
          positionParam:
              new LatLng(locationData.latitude!, locationData.longitude!));
    });
  }

  updateLatLng(CameraPosition _position) {
    setState(() {
      latLng = LatLng(_position.target.latitude, _position.target.longitude);
    });
  }

  _updatePosition() {
    geoc
        .placemarkFromCoordinates(latLng!.latitude, latLng!.longitude)
        .then((addresses) {
      geoc.Placemark first = addresses.first;
      _searchController.text = first.street! +
          ', ' +
          first.administrativeArea! +
          ', ' +
          first.country!;
    });

    setState(() {
      marker = marker.copyWith(
          positionParam: LatLng(latLng!.latitude, latLng!.longitude));
    });
  }

  Widget _buildNewCustomLabel() {
    return ActionChip(
      label: Text(
        AppLocalizations.of(context)!.addLabel,
        style: TextStyle(color: Colors.black),
      ),
      avatar: Icon(Icons.add),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.addLabel),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          if (value.length > 1) {
                            setState(() {
                              customLabels.add(value);
                              selectedLabel = value;
                              _newLabelTextFieldController.text = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                        controller: _newLabelTextFieldController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: AppLocalizations.of(context)!.college,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                        )),
                    TextButton(
                        onPressed: () {
                          if (_newLabelTextFieldController.text.length > 1) {
                            setState(() {
                              customLabels
                                  .add(_newLabelTextFieldController.text);
                              selectedLabel = _newLabelTextFieldController.text;
                              _newLabelTextFieldController.text = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: primaryColor)))
                  ],
                ),
              );
            });
      },
    );
  }
}
