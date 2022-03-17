import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/login_controller.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/logo_box.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../shared_components/responsive_builder.dart';

class LoginPage extends GetView<LoginController> {
  static const String route = '/login';

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _editingController =
      TextEditingController(text: 'david@test.de');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
      ),
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
            margin: EdgeInsets.symmetric(horizontal: size.width / 10, vertical: 25),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius)),
            child: Container(
              width: 1280,
              height: (constraints.maxWidth >= 1000) ? 650 : null,
              child: (constraints.maxWidth >= 1000)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
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
                                  AppLocalizations.of(context).loginButton,
                                  style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5),
                                ),
                                const SizedBox(
                                  height: kSpacing * 2,
                                ),
                                RoundedInput(
                                  size: size,
                                  icon: Icons.email,
                                  labelText:
                                      AppLocalizations.of(context).emailLabel,
                                  controller: _editingController,
                                  validator: (String value) => value == null ||
                                          value.isBlank
                                      ? AppLocalizations.of(context).emptyError
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
                                            .loginButton,
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            controller.onLogin(
                                                _editingController.text,
                                                context);
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: kSpacing * 2,
                                      ),
                                      MyFlatButton(
                                        width: size.width,
                                        buttonText: AppLocalizations.of(context)
                                            .registerButton,
                                        onPressed: controller.onRegister,
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
                                    borderRadius: BorderRadius.circular(kBorderRadius * 2),
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
                             icon: Icons.email,
                            size: size,
                            labelText: AppLocalizations.of(context).emailLabel,
                            controller: _editingController,
                            validator: (String value) =>
                                value == null || value.isBlank
                                    ? AppLocalizations.of(context).emptyError
                                    : null,
                          ),
                          const SizedBox(height: kSpacing * 2),
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
                                      controller.onLogin(
                                          _editingController.text, context);
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: kSpacing,
                                ),
                                MyFlatButton(
                                  width: size.width,
                                  buttonText:
                                      AppLocalizations.of(context).registerButton,
                                  onPressed: controller.onRegister,
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

  Widget form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LogoBox(),
          MyTextFormField(
            minLines: 1,
            maxLines: 3,
            controller: _editingController,
            labelText: AppLocalizations.of(context).emailLabel,
            icon: Icons.email,
            validator: (String value) => value == null || value.isBlank
                ? AppLocalizations.of(context).emptyError
                : null,
          ),
          const SizedBox(
            height: 20.0,
          ),
          MyRaisedButton(
            buttonText: AppLocalizations.of(context).loginButton,
            onPressed: () {
              // TODO(armin)
              //if (_formKey.currentState.validate()) {
              //controller.onLogin(_editingController.text, context);
              //}
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          MyFlatButton(
            buttonText: AppLocalizations.of(context).registerButton,
            onPressed: controller.onRegister,
          )
        ],
      ),
    );
  }
}
