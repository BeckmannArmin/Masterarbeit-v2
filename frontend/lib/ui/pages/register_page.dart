import 'dart:math';

import 'package:beebusy_app/controller/register_controller.dart';
import 'package:beebusy_app/shared_components/responsive_builder.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/logo_box.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_constants.dart';

class RegisterPage extends GetView<RegisterController> {
  static const String route = '/register';

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _surNameEditingController =
      TextEditingController();
  final TextEditingController _mailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MyScaffold(
      body: Center(
          child: ResponsiveBuilder(
        mobileBuilder: (BuildContext context, BoxConstraints constraints) {
          return formResponsive(context, constraints);
        },
        tabletBuilder: (BuildContext context, BoxConstraints constraints) {
          return formResponsive(context, constraints);
        },
        desktopBuilder: (BuildContext context, BoxConstraints constraints) {
          return formResponsive(context, constraints);
        },
      )),
    );
  }

  Widget formResponsive(BuildContext context, BoxConstraints constraints) {
    final Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Container(
        child: Center(
          child: Card(
            elevation: (constraints.maxWidth >= 1000) ? 5 : 0,
            margin:
                EdgeInsets.symmetric(horizontal: size.width / 10, vertical: 25),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius)),
            child: Container(
              width: 1280,
              height: (constraints.maxWidth >= 1000) ? 650 : null,
              child: (constraints.maxWidth >= 1000)
                  ? Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).registerButton,
                                  style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5),
                                ),
                                const SizedBox(
                                  height: kSpacing,
                                ),
                                RoundedInput(
                                  icon: Icons.account_circle,
                                  size: size,
                                  labelText: AppLocalizations.of(context)
                                      .firstnameLabel,
                                  controller: _firstNameEditingController,
                                  validator: (String value) => value == null ||
                                          value.isBlank
                                      ? AppLocalizations.of(context).emptyError
                                      : null,
                                ),
                                const SizedBox(height: kSpacing),
                                RoundedInput(
                                   icon: Icons.account_circle,
                                  size: size,
                                  labelText: AppLocalizations.of(context)
                                      .lastnameLabel,
                                  controller: _surNameEditingController,
                                  validator: (String value) => value == null ||
                                          value.isBlank
                                      ? AppLocalizations.of(context).emptyError
                                      : null,
                                ),
                                const SizedBox(height: kSpacing),
                                RoundedInput(
                                  size: size,
                                   icon: Icons.email,
                                  labelText:
                                      AppLocalizations.of(context).emailLabel,
                                  controller: _mailEditingController,
                                  validator: (String value) => !value.isEmail
                                      ? AppLocalizations.of(context)
                                          .invalidEmailError(
                                              '${value.substring(0, min(12, value.length))}${value.length > 10 ? '...' : ''}')
                                      : null,
                                ),
                                const SizedBox(height: kSpacing * 2),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      MyRaisedButton(
                                        width: size.width,
                                        buttonText: AppLocalizations.of(context)
                                            .submitButton,
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            controller.onRegister(
                                              firstname:
                                                  _firstNameEditingController
                                                      .text,
                                              lastname:
                                                  _surNameEditingController
                                                      .text,
                                              email:
                                                  _mailEditingController.text,
                                              context: context,
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: kSpacing * 2,
                                      ),
                                      MyFlatButton(
                                        width: size.width,
                                        buttonText: AppLocalizations.of(context)
                                            .backButton,
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      const SizedBox(height: kSpacing),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Material(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          kBorderRadius * 2),
                                      child: Image.asset(
                                          'images/flutter-login.png')),
                                ),
                              ))
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).loginButton,
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: kSpacing * 2,
                          ),
                          RoundedInput(
                             icon: Icons.account_circle,
                            size: size,
                            labelText:
                                AppLocalizations.of(context).firstnameLabel,
                            controller: _firstNameEditingController,
                            validator: (String value) =>
                                value == null || value.isBlank
                                    ? AppLocalizations.of(context).emptyError
                                    : null,
                          ),
                          const SizedBox(height: kSpacing),
                          RoundedInput(
                            icon: Icons.account_circle,
                            size: size,
                            labelText:
                                AppLocalizations.of(context).lastnameLabel,
                            controller: _surNameEditingController,
                            validator: (String value) =>
                                value == null || value.isBlank
                                    ? AppLocalizations.of(context).emptyError
                                    : null,
                          ),
                          const SizedBox(height: kSpacing),
                          RoundedInput(
                             icon: Icons.email,
                            size: size,
                            labelText: AppLocalizations.of(context).emailLabel,
                            controller: _mailEditingController,
                            validator: (String value) => !value.isEmail
                                ? AppLocalizations.of(context).invalidEmailError(
                                    '${value.substring(0, min(12, value.length))}${value.length > 10 ? '...' : ''}')
                                : null,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius)),
                            child: Column(
                              children: [
                                MyRaisedButton(
                                  width: size.width,
                                  buttonText:
                                      AppLocalizations.of(context).loginButton,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      controller.onRegister(
                                        firstname:
                                            _firstNameEditingController.text,
                                        lastname:
                                            _surNameEditingController.text,
                                        email: _mailEditingController.text,
                                        context: context,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: kSpacing,
                                ),
                                MyFlatButton(
                                  width: size.width,
                                  buttonText:
                                      AppLocalizations.of(context).backButton,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
