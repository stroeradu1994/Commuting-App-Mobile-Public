import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/screens/account/phone_verification.dart';
import 'package:commuting_app_mobile/services/account_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'account_wrapper.dart';

class PhoneInput extends StatefulWidget {
  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  String phone = '';
  PhoneNumber? phoneNumber;
  bool isPhoneValid = true;
  bool isPhoneValidError = false;

  late TextEditingController phoneCtrl;

  var accountService = locator.get<AccountService>();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneCtrl = new TextEditingController(text: phone);
  }

  @override
  Widget build(BuildContext context) {
    return AccountWrapper(
        children: [
          _buildInput(),
          _buildAction(),
        ],
        title: AppLocalizations.of(context)!.phoneInputTitle,
        image: 'assets/images/Step 3_Flatline.svg',
        info: Text(AppLocalizations.of(context)!.phoneInputInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: .8,
                color: textColorShade1,
                fontSize: 13,
                fontWeight: FontWeight.w400)));
  }

  Widget _buildAction() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ElevatedButton(
          onPressed: () async {
            if (isPhoneValid) {
              setState(() {
                loading = true;
              });

              await accountService.phoneAuthentication(
                  new PhoneNumberAuthenticationRequest(
                      phoneNumber: phone));

              setState(() {
                loading = false;
              });

              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => PhoneVerification(phone)),
              );
            } else {
              setState(() {
                isPhoneValidError = true;
              });
            }
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

  Widget _buildInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  phone = number.phoneNumber!;
                  isPhoneValidError = false;
                });
              },
              onInputValidated: (bool value) {
                setState(() {
                  isPhoneValid = value;
                });
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: phoneNumber,
              textFieldController: phoneCtrl,
              formatInput: false,
              spaceBetweenSelectorAndTextField: 6,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: InputBorder.none,
              onSaved: (PhoneNumber number) {
              },
            ),
          ),
        ),
        !isPhoneValidError
            ? SizedBox(
                height: 0,
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: accentColor),
                    SizedBox(
                      width: 8,
                    ),
                    Text(AppLocalizations.of(context)!.phoneInputError,
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w400,
                            color: accentColor))
                  ],
                ),
              ),
      ],
    );
  }
}
