import 'package:flutter/material.dart';

import '../../service/SizeConfig.dart';

class HeaderImage extends StatelessWidget {
  String title, subtitle, initials;

  HeaderImage({this.title, this.subtitle, this.initials});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Container(
      child: ListTile(
        minLeadingWidth: 150,
          contentPadding: const EdgeInsets.all(15),
          leading: AssigneeAvatar(firstname: title, surName: subtitle, nameInitials: initials,) ,

          title: Align(
            child: Text(
              title,
              style:
              TextStyle(fontSize: MySize.size18, fontWeight: FontWeight.w600),
            ),
            alignment: const Alignment(-1.2, 0),
          ),
          subtitle:
          Align(
            alignment: const Alignment(-1.2, 0),
            child: Text(
              subtitle,
              style: TextStyle(
                  fontSize: MySize.size14, fontWeight: FontWeight.normal),
            ),
          ),
      ),
    );
  }
}


class AssigneeAvatar extends StatelessWidget {
  const AssigneeAvatar({Key key, this.firstname, this.surName, this.nameInitials}) : super(key: key);

  final String firstname;
  final String surName;
  final String nameInitials;

  @override
  Widget build(BuildContext context) {
    final String fullName =
        '${firstname ?? ""} ${surName ?? ""}';
    return Tooltip(
      message: fullName,
      child: CircleAvatar(
        radius: MySize.size16,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          nameInitials,
          style: TextStyle(
            fontSize: MySize.size14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
