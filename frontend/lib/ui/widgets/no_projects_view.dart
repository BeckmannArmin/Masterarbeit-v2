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
    return Center(
      child: Column(
        children: <Widget>[
          const Spacer(flex: 5),
          Container(
            child: const Canvasllustration(),
          ),
          const Spacer(flex: 2),
          BrownText(AppLocalizations.of(context).noProjectsMessage),
          const SizedBox(height: 10),
          MyRaisedButton(
            buttonText: AppLocalizations.of(context).createProjectTitle,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => GetBuilder<CreateProjectController>(
                init: CreateProjectController(),
                builder: (_) => AddProjectDialog(),
              ),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}

class Canvasllustration extends StatelessWidget {
  const Canvasllustration({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'icons/empty_view.png',
      fit: BoxFit.cover,
    );
  }
}
