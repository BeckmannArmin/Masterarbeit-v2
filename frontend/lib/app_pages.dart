import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/login_controller.dart';
import 'package:beebusy_app/controller/profile_controller.dart';
import 'package:beebusy_app/controller/register_controller.dart';
import 'package:beebusy_app/controller/settings_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/login_page.dart';
import 'package:beebusy_app/ui/pages/onboarding_page.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/pages/register_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[

  GetPage<dynamic>(
    name: OnBoardingPage.route,
    page: () => OnBoardingPage(),
  ),
  GetPage<dynamic>(
    name: RegisterPage.route,
    page: () => RegisterPage(),
    binding: BindingsBuilder<RegisterController>.put(
      () => RegisterController(),
    ),
  ),
  GetPage<dynamic>(
    name: LoginPage.route,
    page: () => LoginPage(),
    binding: BindingsBuilder<LoginController>.put(
      () => LoginController(),
    ),
  ),
  GetPage<dynamic>(
    name: BoardPage.route,
    page: () => BoardPage(),
    bindings: <Bindings>[
      BindingsBuilder<TaskController>.put(() => TaskController()),
      BindingsBuilder<BoardController>.put(() => BoardController()),
    ],
  ),
  GetPage<dynamic>(
    name: SettingsPage.route,
    page: () => SettingsPage(),
    bindings: <Bindings>[
      // TODO(dakr): remove for release
      BindingsBuilder<BoardController>.put(() => BoardController()),
      BindingsBuilder<SettingsController>.put(() => SettingsController()),
    ],
  ),
  GetPage<dynamic>(
    name: ProfilePage.route,
    page: () => ProfilePage(),
    binding: BindingsBuilder<ProfileController>.put(
          () => ProfileController(),
    ),
  ),
];