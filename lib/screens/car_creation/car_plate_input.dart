import 'package:commuting_app_mobile/provider/car_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/new_trip/new_trip.dart';
import 'package:commuting_app_mobile/services/car_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarPlateInput extends StatefulWidget {
  @override
  State<CarPlateInput> createState() => _CarPlateInputState();
}

class _CarPlateInputState extends State<CarPlateInput> {
  var creationService = locator.get<CreationService>();
  var carService = locator.get<CarService>();

  late TextEditingController plateCtrl;
  bool isPlateValid = true;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    plateCtrl = new TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return MainScreen(
        hasBack: true,
        loading: loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            _buildTitle(),
            _buildSmallSpace(),
            _buildInfo(),
            _buildSpace(),
            _buildInput(),
            isPlateValid
                ? SizedBox(
                    height: 0,
                  )
                : _buildError(),
            _buildAction(),
          ],
        ),
        header: AppLocalizations.of(context)!.addNewCar);
  }

  _buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: TextField(
        controller: plateCtrl,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
        onTap: () {
          setState(() {
            isPlateValid = true;
          });
        },
        onChanged: (value) => {
          setState(() {
            creationService.createCarRequest.plate = plateCtrl.text;
          })
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 16,
              color: textColorShade2,
            ),
            hintText: "B 123 ABC",
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor, width: 1.0),
            ),
            contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16)),
      ),
    );
  }

  Widget _buildAction() {
    var carProvider = Provider.of<CarProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ElevatedButton(
          onPressed: () async {
            if (creationService.createCarRequest.plate != null &&
                creationService.createCarRequest.plate!.length < 3) {
              setState(() {
                isPlateValid = false;
              });
            } else {
              setState(() {
                loading = true;
              });

              await carService.createCar(creationService.createCarRequest);
              await carProvider.getCars();

              setState(() {
                loading = false;
              });

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => NewTrip()),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          child: Text(
            AppLocalizations.of(context)!.addNewCar,
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
            'assets/images/Step 3_Outline.svg',
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Text(AppLocalizations.of(context)!.enterCarPlate,
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
        child: Text(AppLocalizations.of(context)!.enterCarPlateInfo,
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

  _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 20, color: accentColor),
          SizedBox(
            width: 8,
          ),
          Text('Plate Number is not valid',
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w400,
                  color: accentColor))
        ],
      ),
    );
  }
}
