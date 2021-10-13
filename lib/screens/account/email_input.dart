import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/screens/account/email_verification.dart';
import 'package:commuting_app_mobile/services/account_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailInput extends StatefulWidget {
  bool isLogin = false;

  EmailInput(this.isLogin);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  String email = '';
  bool isEmailValid = true;

  bool loading = false;

  late TextEditingController emailCtrl;

  var accountService = locator.get<AccountService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailCtrl = new TextEditingController(text: email);
  }

  @override
  Widget build(BuildContext context) {
    return AccountWrapper(
        loading: loading,
        isLogin: widget.isLogin,
        children: [
          _buildInput(),
          _buildAction(),
        ],
        title: AppLocalizations.of(context)!.emailInputTitle,
        image: widget.isLogin ? 'assets/images/undraw_Login_re_4vu2.svg' : 'assets/images/Step 1_Flatline.svg',
        info: Text(AppLocalizations.of(context)!.emailInputInfo,
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
            setState(() {
              isEmailValid = EmailValidator.validate(email);
            });
            if (isEmailValid) {

              setState(() {
                loading = true;
              });

              await accountService.emailAuthentication(new EmailAuthenticationRequest(email: email));

              setState(() {
                loading = false;
              });

              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EmailVerification(email, widget.isLogin)),
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

  Widget _buildInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: emailCtrl,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            onTap: () {
              setState(() {
                isEmailValid = true;
              });
            },
            onChanged: (value) => {
              setState(() {
                email = emailCtrl.text;
              })
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: textColorShade2,
                ),
                hintText: "john.doe@email.com",
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
        isEmailValid
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
                    Text(AppLocalizations.of(context)!.emailInputError,
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
