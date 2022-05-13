import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/navigation/custom_animated_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controller/board_controller.dart';


class MyBottomNavigationBar extends GetView<BoardController> {
  MyBottomNavigationBar({Key key,}) : super(key: key);

  final BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return _buildNavigationBar(context, controller);
  }
}


Widget _buildNavigationBar(BuildContext context, BoardController controller) {
  final Color _inactiveColor = Theme.of(context).colorScheme.primary.withOpacity(.5);
  final Color _activeColor = Theme.of(context).colorScheme.primary;

  return CustomAnimatedBottomBar(
    containerHeight: 70,
    backgroundColor: Theme.of(context).backgroundColor,
    selectedIndex: controller.tabIndex,
    showElevation: true,
    itemCornerRadius: kBorderRadius,
    curve: Curves.easeIn,
    onItemSelected: (int index) {
      controller.changeTabIndex(index);
    },
    items: <BottomNavyBarItem>[
      BottomNavyBarItem(
        icon: const Icon(Icons.apps),
        title: Text(AppLocalizations.of(context).boardLabel),
        activeColor: _activeColor,
        inactiveColor: _inactiveColor,
        textAlign: TextAlign.center,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.settings),
        title: Text(AppLocalizations.of(context).settingsLabel),
        activeColor: _activeColor,
        inactiveColor: _inactiveColor,
        textAlign: TextAlign.center,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.person),
        title: Text(AppLocalizations.of(context).profileLabel),
        activeColor: _activeColor,
        inactiveColor: _inactiveColor,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
