import 'dart:async';

import 'package:commuting_app_mobile/dto/account/add_fcm_token_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/provider/profile_provider.dart';
import 'package:commuting_app_mobile/screens/account/name_input.dart';
import 'package:commuting_app_mobile/screens/trips.dart';
import 'package:commuting_app_mobile/services/account_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import 'account_wrapper.dart';

class PhoneVerification extends StatefulWidget {
  String phone;

  PhoneVerification(this.phone);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {

  late TextEditingController pinCtrl;
  bool isPinValid = true;

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  String pin = '';

  var accountService = locator.get<AccountService>();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pinCtrl = new TextEditingController(text: pin);
  }

  @override
  Widget build(BuildContext context) {
    return AccountWrapper(
        children: [
          _buildInput(),
          SizedBox(height: 32,),
          _buildResend(),
          isPinValid
              ? SizedBox(
            height: 0,
          )
              : _buildError(),
          _buildAction(),
        ],
        title: AppLocalizations.of(context)!.phoneVerificationTitle,
        image: 'assets/images/Step 3_Flatline.svg',
        info: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: AppLocalizations.of(context)!.phoneVerificationInfo,
              style: TextStyle(
                  letterSpacing: .8,
                  color: textColorShade1,
                  height: 1.5,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                    text: widget.phone,
                    style: TextStyle(
                        letterSpacing: .8,
                        color: textColor2,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap = () {})
              ]),
        ));
  }

  _buildTitle() {}

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: PinCodeTextField(
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          inactiveColor: primaryColor,
          selectedColor: accentColor,
          activeColor: primaryColor,
          fieldWidth: 40,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        cursorColor: Colors.white,
        errorAnimationController: errorController,
        controller: pinCtrl,
        onCompleted: (v) {
        },
        onChanged: (value) {
          setState(() {
            pin = value;
          });
        },
        beforeTextPaste: (text) {
          return true;
        },
        appContext: context,
      ),
    );
  }

  _buildResend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: RichText(
          text: TextSpan(
              text: AppLocalizations.of(context)!.phoneVerificationNoReceive,
              style: TextStyle(
                  letterSpacing: .8,
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                    text: AppLocalizations.of(context)!.phoneVerificationResend,
                    style: TextStyle(
                        letterSpacing: .8,
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()..onTap = () {})
              ]),
        ),
      ),
    );
  }

  Widget _buildAction() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ElevatedButton(
          onPressed: () async {
            setState(() {
              String pinText = pinCtrl.text;
              isPinValid = pinText.length == 4 && double.tryParse(pinText) != null;
            });
            if (isPinValid) {

              setState(() {
                loading = true;
              });

              await accountService.phoneVerification(new PhoneNumberVerificationRequest(code: pinCtrl.text, phoneNumber: widget.phone));
              // await sendFcmTokenAndGetProfile();

              setState(() {
                loading = false;
              });

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => MyApp()),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          child: Text(
            AppLocalizations.of(context)!.phoneVerificationAction,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  _buildError() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 20, color: accentColor),
          SizedBox(
            width: 8,
          ),
          Text(AppLocalizations.of(context)!.phoneVerificationError,
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w400,
                  color: accentColor))
        ],
      ),
    );
  }
  // Future sendFcmTokenAndGetProfile() async {
  //   var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  //
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   await accountService.addFcmToken(new AddFcmTokenRequest(token: token!));
  //   await profileProvider.getProfile();
  //   return Future.value(true);
  // }

}
