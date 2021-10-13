import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'car_model.dart';
import 'car_plate_input.dart';

class CarColorInput extends StatefulWidget {

  @override
  State<CarColorInput> createState() => _CarColorInputState();
}

class _CarColorInputState extends State<CarColorInput> {

  var creationService = locator.get<CreationService>();

  // late List<String> colors = [AppLocalizations.of(context)!.white, AppLocalizations.of(context)!.black, AppLocalizations.of(context)!.gray, AppLocalizations.of(context)!.blue, AppLocalizations.of(context)!.yellow, AppLocalizations.of(context)!.green];

  late List<KeyValueRecordType> colors = <KeyValueRecordType>[
    KeyValueRecordType(key: AppLocalizations.of(context)!.white, value: AppLocalizations.of(context)!.white),
    KeyValueRecordType(key: AppLocalizations.of(context)!.black, value: AppLocalizations.of(context)!.black),
    KeyValueRecordType(key: AppLocalizations.of(context)!.gray, value: AppLocalizations.of(context)!.gray),
    KeyValueRecordType(key: AppLocalizations.of(context)!.blue, value: AppLocalizations.of(context)!.blue),
    KeyValueRecordType(key: AppLocalizations.of(context)!.yellow, value: AppLocalizations.of(context)!.yellow),
    KeyValueRecordType(key: AppLocalizations.of(context)!.green, value: AppLocalizations.of(context)!.green),
  ];

  late KeyValueRecordType recordType = colors[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {

    return MainScreen(
        hasBack:true,
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
      child: DropdownButtonFormField<KeyValueRecordType>(
        value: recordType,
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
        onChanged: (KeyValueRecordType? newValue) {
          setState(() {
            recordType = newValue!;
            creationService.createCarRequest.color = newValue.value;
          });
        },
        items: colors.map<DropdownMenuItem<KeyValueRecordType>>((KeyValueRecordType value) {
          return DropdownMenuItem<KeyValueRecordType>(
            value: value,
            child: Text(value.value),
          );
        }).toList(),
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
              CupertinoPageRoute(builder: (context) => CarPlateInput()),
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
            'assets/images/Step 2_Outline.svg',
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Text(AppLocalizations.of(context)!.enterCarColor,
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
        child: Text(AppLocalizations.of(context)!.enterCarColorInfo,
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

class KeyValueRecordType extends Equatable {
  String key;
  String value;

  KeyValueRecordType({required this.key, required this.value});

  @override
  List<Object> get props => [key, value];
}
