import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/ui/widgets/add_project_dialog.dart';
import 'package:beebusy_app/ui/widgets/add_project_dialogv2.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';

class NoProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          width < 1000 ? const EdgeInsets.all(15) : const EdgeInsets.all(25),
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const EmptyViewImage(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 450),
                child: Wrap(spacing: 15, runSpacing: 15, children: <Widget>[
                  Flexible(
                      child: BrownText(
                    AppLocalizations.of(context).noProjectsMessage,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  )),
                  const Spacer(flex: 2),
                  MyRaisedButton(
                    buttonText: AppLocalizations.of(context).createProjectTitle,
                    onPressed: () => width < 1000
                        ? showModalBottomSheet<void>(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(kBorderRadius),
                                  topLeft: Radius.circular(kBorderRadius)),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            context: context,
                            builder: (BuildContext context) {
                              return GetBuilder<CreateProjectController>(
                                init: CreateProjectController(),
                                builder: (_) => AddModalProjectDialog(),
                              );
                            })
                        : showDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                GetBuilder<CreateProjectController>(
                              init: CreateProjectController(),
                              builder: (_) => AddProjectDialog(),
                            ),
                          ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyViewImage extends StatelessWidget {
  const EmptyViewImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'icons/empty_view.png',
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width > 800 ? 625 : 350,
      height: MediaQuery.of(context).size.width > 800 ? 450 : 350,
    );
  }
}
