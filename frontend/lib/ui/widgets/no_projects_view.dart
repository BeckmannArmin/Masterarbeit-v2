import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/ui/widgets/add_project_dialog.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: width < 1000 ? const EdgeInsets.all(15) : const EdgeInsets.all(25),
      child: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              const EmptyViewImage(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 450),
                child: Wrap(spacing: 15, runSpacing: 20, children: <Widget>[
                  Flexible(
                      child: BrownText(
                          AppLocalizations.of(context).noProjectsMessage,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          )),
                  MyRaisedButton(
                    buttonText: AppLocalizations.of(context).createProjectTitle,
                    onPressed: () => showDialog<void>(
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
    );
  }
}
