import 'dart:developer';

import 'package:beebusy_app/shared_components/selection_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          const Divider(thickness: 1),
          SelectionButton(
            data: [
              SelectionButtonData(
                activeIcon: EvaIcons.grid,
                icon: EvaIcons.gridOutline,
                label: 'Dashboard',
              ),
              SelectionButtonData(
                activeIcon: EvaIcons.grid,
                icon: EvaIcons.archiveOutline,
                label: 'Reports',
              ),
              SelectionButtonData(
                activeIcon: EvaIcons.grid,
                icon: EvaIcons.personOutline,
                label: 'Profil',
              ),
              SelectionButtonData(
                activeIcon: EvaIcons.grid,
                icon: EvaIcons.settingsOutline,
                label: 'Settings',
              ),
            ],
            onSelected: (int index,  SelectionButtonData value) {
              log('index : $index | label : ${value.label}');
            },
          ),
          const Divider(thickness: 1,),
          
        ],
      ),
    );
  }
}