import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/screens/account/phone_input.dart';
import 'package:commuting_app_mobile/services/account_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'account_wrapper.dart';
import 'email_verification.dart';

class NameInput extends StatefulWidget {
  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  String firstName = '';
  String lastName = '';

  bool isFirstNameValid = true;
  bool isLastNameValid = true;

  late TextEditingController firstNameCtrl;
  late TextEditingController lastNameCtrl;

  var accountService = locator.get<AccountService>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    firstNameCtrl = new TextEditingController(text: firstName);
    lastNameCtrl = new TextEditingController(text: lastName);
  }

  @override
  Widget build(BuildContext context) {
    return AccountWrapper(
        loading: loading,
        children: [
          _buildInput(),
          SizedBox(
            height: 16,
          ),
          _buildAction(),
        ],
        title: AppLocalizations.of(context)!.nameInputTitle,
        image: 'assets/images/Step 2_Flatline.svg',
        info: Text(AppLocalizations.of(context)!.nameInputInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: .8,
                color: textColorShade1,
                fontSize: 13,
                fontWeight: FontWeight.w400)));
  }

  _buildInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: firstNameCtrl,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            onTap: () {
              setState(() {
                isFirstNameValid = true;
              });
            },
            onChanged: (value) => {
              setState(() {
                firstName = firstNameCtrl.text;
              })
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: textColorShade2,
                ),
                hintText: AppLocalizations.of(context)!.nameFirstInputLabel,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                contentPadding:
                    EdgeInsets.only(left: 16.0, right: 16.0, top: 16)),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: lastNameCtrl,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            onTap: () {
              setState(() {
                isLastNameValid = true;
              });
            },
            onChanged: (value) => {
              setState(() {
                lastName = lastNameCtrl.text;
              })
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: textColorShade2,
                ),
                hintText: AppLocalizations.of(context)!.nameLastInputLabel,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                ),
                contentPadding:
                    EdgeInsets.only(left: 16.0, right: 16.0, top: 16)),
          ),
        ),
        isFirstNameValid
            ? SizedBox(
                height: 0,
              )
            : Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, right: 32.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: accentColor),
                    SizedBox(
                      width: 8,
                    ),
                    Text(AppLocalizations.of(context)!.nameFirstInputError,
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w400,
                            color: accentColor))
                  ],
                ),
              ),
        isLastNameValid
            ? SizedBox(
                height: 0,
              )
            : Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, right: 32.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: accentColor),
                    SizedBox(
                      width: 8,
                    ),
                    Text(AppLocalizations.of(context)!.nameLastInputError,
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

  _buildAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ElevatedButton(
          onPressed: () async {
            setState(() {
              isFirstNameValid = firstName.length > 2;
              isLastNameValid = lastName.length > 2;
            });
            if (isFirstNameValid && isLastNameValid) {
              setState(() {
                loading = true;
              });

              await accountService.addName(
                  new AddNameRequest(
                      firstName: firstName, lastName: lastName));

              setState(() {
                loading = false;
              });

              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => PhoneInput()),
              );
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
}
