import 'package:beebusy_app/shared_components/profile_user.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ProfilTile extends StatelessWidget {
  const ProfilTile({this.data, this.onPressedNotification, Key key})
      : super(key: key);

  final ProfileUser data;
  final Function() onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        data.name,
        style: const TextStyle(
            fontSize: 14, color: kColorBlack, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        data.email,
        style: const TextStyle(fontSize: 12, color: kColorBlack),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: onPressedNotification,
        icon: const Icon(EvaIcons.bellOutline),
        tooltip: 'notification',
      ),
    );
  }
}
