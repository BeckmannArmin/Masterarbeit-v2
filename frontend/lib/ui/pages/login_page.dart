import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/login_controller.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/logo_box.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared_components/responsive_builder.dart';

class LoginPage extends GetView<LoginController> {
  static const String route = '/login';

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _editingController =
      TextEditingController(text: 'david@test.de');

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }

  Widget formResponsive(BuildContext context, BoxConstraints constraints) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Center(
        child: Card(
          elevation: 5,
          margin: (constraints.maxWidth >= 1000)
              ? const EdgeInsets.symmetric(horizontal: 130, vertical: 25)
              : const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius)),
          child: Container(
            width: double.infinity,
            height: (constraints.maxWidth >= 1000) ? 650 : null,
            child: (constraints.maxWidth >= 1000)
                ? Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).loginButton,
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: kSpacing * 2,
                              ),
                              const TextField(
                                  cursorColor: kPrimaryColor,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.mail, color: kPrimaryColor),
                                    hintText: 'E-Mail',
                                    border: InputBorder.none
                                  ),
                              ),
                              const SizedBox(height: kSpacing,),
                              MyTextFormField(
                                minLines: 1,
                                maxLines: 3,
                                controller: _editingController,
                                labelText:
                                    AppLocalizations.of(context).emailLabel,
                                icon: Icons.mail,
                                validator: (String value) => value == null ||
                                        value.isBlank
                                    ? AppLocalizations.of(context).emptyError
                                    : null,
                              ),
                              const SizedBox(height: kSpacing * 2),
                              Container(
                                width: double.infinity,
                                color: Colors.red.shade300,
                                child: Column(
                                  children: [
                                    MyRaisedButton(
                                      width: double.infinity,
                                      buttonText: AppLocalizations.of(context)
                                          .loginButton,
                                      onPressed: () {
                                        // TODO(armin)
                                        //if (_formKey.currentState.validate()) {
                                        //controller.onLogin(_editingController.text, context);
                                        //}
                                      },
                                    ),
                                    const SizedBox(
                                      height: kSpacing,
                                    ),
                                    MyFlatButton(
                                      width: double.infinity,
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
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                                child: Image.asset('images/flutter-login.png'),
                              ),
                            ))
                      ],
                    ),
                  )
                : Column(
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
                      RoundedInput(size: size),
                      MyTextFormField(
                        minLines: 1,
                        maxLines: 3,
                        controller: _editingController,
                        labelText: AppLocalizations.of(context).emailLabel,
                        icon: Icons.email,
                        validator: (String value) =>
                            value == null || value.isBlank
                                ? AppLocalizations.of(context).emptyError
                                : null,
                      ),
                      const SizedBox(height: kSpacing * 2),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorderRadius)),
                        child: Column(
                          children: [
                            MyRaisedButton(
                              width: size.width,
                              buttonText:
                                  AppLocalizations.of(context).loginButton,
                              onPressed: () {
                                // TODO(armin)
                                //if (_formKey.currentState.validate()) {
                                //controller.onLogin(_editingController.text, context);
                                //}
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
