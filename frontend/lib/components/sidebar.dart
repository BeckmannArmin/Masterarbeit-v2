import 'dart:developer';

import 'package:beebusy_app/shared_components/selection_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../shared_components/project_card.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key key, this.data}) : super(key: key);

  final ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: ProjectCard(data: data),
              ),
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
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  label: 'Reports',
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: 'Profil',
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
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
      ),
    );
  }
}