import 'package:beebusy_app/components/sidebar.dart';
import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/shared_components/profile_tile.dart';
import 'package:beebusy_app/shared_components/progress_card.dart';
import 'package:beebusy_app/shared_components/responsive_builder.dart';
import 'package:beebusy_app/shared_components/team_member.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../components/active_project_card.dart';
import '../../components/header.dart';
import '../../components/overview_header.dart';
import '../../shared_components/list_profile_image.dart';
import '../../shared_components/profile_user.dart';
import '../../shared_components/progress_report_card.dart';
import '../../shared_components/project_card.dart';
import '../../shared_components/task_card.dart';

class DashboardPage extends GetView<BoardController> {
  static const String route = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: SideBar(data: controller.getSelectedProject()),
              ),
            ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [],
          );
        },
        tabletBuilder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child:
                 Column(
                   children:  [
                     const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                      _buildHeader(onPressedMenu: () => controller.openDrawer()),
                      const SizedBox(height: kSpacing * 2,),
                      _buildProgress(
                        axis: (constraints.maxWidth < 950)
                            ? Axis.vertical
                            : Axis.horizontal
                      ),
                      const SizedBox(height: kSpacing * 2,),
                      //_buildTaskOverview(
                        //data: controller.getAllTask(),
                        //headerAxis: (constraints.maxWidth < 850)
                            //? Axis.vertical
                            //: Axis.horizontal,
                        //crossAxisCount: 6,
                      //),
                      const SizedBox(height: kSpacing * 2,),
                      _buildActiveProject(
                        data: controller.getActiveProject(),
                        crossAxisCount: 6,
                        crossAxisCellCount: (constraints.maxWidth < 950)
                             ? 6
                             : (constraints.maxWidth < 1100)
                             ? 3
                             :2,
                      ),
                      const SizedBox(height: kSpacing,)
                   ],
                 )
                 ),
                 Flexible(
                   flex: 4,
                   child: Column(
                     children: [
                       const SizedBox(height: kSpacing * ( kIsWeb ? 0.5 : 1.5 ),),
                       _buildProfile(data: controller.getProfil()),
                       const Divider(thickness: 1),
                       const SizedBox(height: kSpacing,),
                       _buildTeamMember(data: controller.getTeamMembers()),
                     ],
                   )
                   ),
                 ],
          );
        },
        desktopBuilder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(kBorderRadius),
                    bottomRight: Radius.circular(kBorderRadius),
                  ),
                  child: SideBar(data: controller.getSelectedProject()),
                ),
                ),
                Flexible(
                  flex: 9,
                  child: 
                  Column(

                  )
                  )
            ],
          );
        },
      )),
    );
  }
}


/* -----------------------------> WIDGETS <---------------------------- */


 Widget _buildTeamMember({List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

Widget _buildProfile({ProfileUser data}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: kSpacing),
    child: ProfilTile(
      data: data,
      onPressedNotification: () {},
    ),
  );
}

Widget _buildHeader({ Function() onPressedMenu }) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kSpacing
      ),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(padding: 
              const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu, 
                icon: const Icon(EvaIcons.menu),
                tooltip: 'menu',
                ),
            ),
            const Expanded(child: SideMenuHeader()),
        ],
      ),
      );
}


Widget _buildProgress({Axis axis = Axis.horizontal}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: kSpacing),
    child: (axis == Axis.horizontal)
      ? Row(
        children: [
          Flexible(
            flex: 4,
            child: ProgressCard(
              data: const ProgressCardData(
                totalUndone: 10,
                totalTaskInProgress: 2,
              ),
              onPressedCheck: () {},
            ),
            ),
            const SizedBox(width: kSpacing / 2,),
            const Flexible(
              flex: 4,
              child: ProgressReportCard(
                data: ProgressReportCardData(
                  title: '1. Sprint',
                  doneTask: 5,
                  percent: .3,
                  task: 3,
                  undoneTask: 2
                ),
              ),
              ),
        ],
      )
      : Column(
        children: [
          ProgressCard(
            data: const ProgressCardData(
              totalUndone: 10,
              totalTaskInProgress: 2
            ),
            onPressedCheck: () {},
          ),
          const SizedBox(height: kSpacing / 2,),
          const ProgressReportCard(
            data: ProgressReportCardData(
              title: '1. Sprint',
              doneTask: 5,
              percent: .3,
              task: 3,
              undoneTask: 2
            ),
          )
        ],
      )
    );
}

Widget _buildActiveProject({
    List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }

Widget _buildTaskOverview({
    List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
              );
      },
       staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(crossAxisCellCount),
    );
  }