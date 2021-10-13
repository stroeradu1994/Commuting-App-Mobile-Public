import 'dart:convert';

import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'car_color_input.dart';
import 'car_model.dart';

class CarBrandModelInput extends StatefulWidget {
  @override
  State<CarBrandModelInput> createState() => _CarBrandModelInputState();
}

class _CarBrandModelInputState extends State<CarBrandModelInput> {

  var creationService = locator.get<CreationService>();

  late List<CarModel> cars = [];
  late List<String> carBrands = [];
  late List<String> carModels = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var tagObjsJson = jsonDecode(snapshot.data!) as List;
            cars = tagObjsJson
                .map((tagJson) => CarModel.fromJson(tagJson))
                .toList();
            carBrands = cars.map((e) => e.brand).toList();
            carBrands.sort((a, b) {
              return a.toLowerCase().compareTo(b.toLowerCase());
            });
            _getModels();

            return _buildBody();
          } else {
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
        future: getJson(),
      );
    } else {
      return _buildBody();
    }
  }

  _getModels() {
    carModels = cars.where((element) => element.brand == creationService.createCarRequest.brand).first.models;
    carModels.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    creationService.createCarRequest.model = carModels.first;
  }

  _buildBody() {
    return MainScreen(
        hasBack: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            _buildTitle(),
            _buildSmallSpace(),
            _buildInfo(),
            _buildSpace(),
            _buildInput(),
            _buildAction(),
          ],
        ),
        header: AppLocalizations.of(context)!.addNewCar);
  }

  _buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: creationService.createCarRequest.brand,
            icon: const Icon(Icons.arrow_downward, size: 16),
            iconSize: 16,
            // menuMaxHeight: 500,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor, width: 1.0),
              ),
            ),
            // alignment: Alignment.center,
            elevation: 0,
            style: TextStyle(fontSize: 16, color: textColor),
            onChanged: (String? newValue) {
              setState(() {
                creationService.createCarRequest.brand = newValue!;
                _getModels();
              });
            },
            items: carBrands.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(
            height: 32,
          ),
          DropdownButtonFormField<String>(
            value: creationService.createCarRequest.model,
            icon: const Icon(Icons.arrow_downward, size: 16),
            iconSize: 16,
            // menuMaxHeight: 500,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor, width: 1.0),
              ),
            ),
            // alignment: Alignment.center,
            elevation: 0,
            style: TextStyle(fontSize: 16, color: textColor),
            onChanged: (String? newValue) {
              setState(() {
                creationService.createCarRequest.model = newValue!;
              });
            },
            items: carModels.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAction() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => CarColorInput()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          child: Text(
            AppLocalizations.of(context)!.continueText,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  _buildSpace() {
    return SizedBox(
      height: 32,
    );
  }

  _buildSmallSpace() {
    return SizedBox(
      height: 16,
    );
  }

  _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/Step 1_Outline.svg',
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Text(AppLocalizations.of(context)!.enterCarBrand,
            style: TextStyle(
                letterSpacing: 1,
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Padding _buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Text(AppLocalizations.of(context)!.enterCarBrandInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: .8,
                color: textColorShade1,
                fontSize: 13,
                fontWeight: FontWeight.w400)),
      ),
    );
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/json/car_list.json');
  }
}
