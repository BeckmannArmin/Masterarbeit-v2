import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:beebusy_app/controller/profile_controller.dart';
import 'package:beebusy_app/ui/widgets/alert_dialog.dart';
import 'package:beebusy_app/ui/widgets/profile_list_item.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:beebusy_app/utils/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class ProfilePage extends GetView<ProfileController> {
  static const String route = '/profile';

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context, height: height, width: width, allowFontScaling: true);

    final Expanded profileInfo = Expanded(
      child: Form(
        key: controller.formKey,
        child: Obx(
          () => Column(
            children: <Widget>[
              Container(
                height: (kSpacingUnit.w * 10).toDouble(),
                width: (kSpacingUnit.w * 10).toDouble(),
                margin: EdgeInsets.only(top: (kSpacingUnit.w * 3).toDouble()),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: (kSpacingUnit.w * 5).toDouble(),
                      child: Text(
                        controller.currentUser.nameInitials ?? '',
                        style: kTitleTextStyle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: controller.isEditing.value
                          ? InkWell(
                              onTap: () => controller.savePressed(context),
                              child: Container(
                                height: (kSpacingUnit.w * 2.5).toDouble(),
                                width: (kSpacingUnit.w * 1.5).toDouble(),
                                child: Icon(
                                  Icons.save,
                                  color: Theme.of(context).primaryColor,
                                  size: ScreenUtil()
                                      .setSp(kSpacingUnit.w * 2)
                                      .toDouble(),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => controller.editPressed(),
                              child: Container(
                                height: (kSpacingUnit.w * 2.5).toDouble(),
                                width: (kSpacingUnit.w * 1.5).toDouble(),
                                child: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                  size: ScreenUtil()
                                      .setSp(kSpacingUnit.w * 2)
                                      .toDouble(),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (controller.isEditing.value)
                      AlertDialog(
                        alignment: Alignment.center,
                        elevation: 5,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextFormField(
                            controller: controller.firstNameEditingController,
                            labelText:
                                AppLocalizations.of(context).firstnameLabel,
                          ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextFormField(
                            controller: controller.surNameEditingController,
                            labelText:
                                AppLocalizations.of(context).lastnameLabel,
                          ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextFormField(
                            controller: controller.mailEditingController,
                            labelText:
                                AppLocalizations.of(context).emailLabel,
                          ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(color: Colors.blue)
                  ],
                ),
              ),
              SizedBox(height: (kSpacingUnit.w * 2).toDouble()),
              Text(
                controller.currentUser.firstname ?? '',
                style: kTitleTextStyle,
              ),
              SizedBox(height: (kSpacingUnit.w * .5).toDouble()),
              Text(
                controller.currentUser.email ?? '',
                style: kCaptionTextStyle,
              ),
              SizedBox(height: (kSpacingUnit.w * 2).toDouble()),
              InkWell(
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => MyAlertDialog(
                    title: AppLocalizations.of(context).deleteUserButton,
                    content: AppLocalizations.of(context).deleteUserQuestion,
                    onConfirm: controller.deleteUserPressed,
                  ),
                ),
                child: Container(
                  height: (kSpacingUnit.w * 4).toDouble(),
                  width: (kSpacingUnit.w * 20).toDouble(),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular((kSpacingUnit.w * 3).toDouble()),
                    color: const Color(0XFFFAAB21),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).deleteUserButton,
                      style: TextStyle(
                        color: Get.isDarkMode ? const Color(0XFF1A1103) : const Color(0xFF593D0C)
                      ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: (kSpacingUnit.w * 3.5).toDouble()),
            ],
          ),
        ),
      ),
    );

    final ThemeSwitcher themeSwitcher = ThemeSwitcher(
      builder: (BuildContext context) {
        return   ValueBuilder<bool>(
                initialValue: Get.isDarkMode,
                builder: (bool isDarkMode, void updater(bool _)) {
                  return Switch(
                    value: isDarkMode,
                    onChanged: (bool isDarkMode) {
                      updater(isDarkMode);
                      final GetStorage storage = GetStorage('theme');
                      storage.write('isDarkMode', isDarkMode);
                      Get.changeThemeMode(
                        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                  );
                },
              );
      },
    );

    final Row header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        profileInfo,
      ],
    );

    return Scaffold(
          body: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: (kSpacingUnit.w * 5).toDouble()),
                  header,
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        InkWell(
                           onTap: () {
                            print('test');
                          },
                          child: ProfileListItem(
                            icon: Icons.dark_mode_outlined,
                            text: 'Dunkel Modus',
                            hasNavigation: false,
                            hasWidget: true,
                            widget: themeSwitcher,
                          ),
                        ),
                        InkWell(
                           onTap: () {
                            controller.logoutUser();
                          },
                          child: const ProfileListItem(
                            icon: Icons.logout,
                            text: 'Logout',
                            hasNavigation: false,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
  }
}
