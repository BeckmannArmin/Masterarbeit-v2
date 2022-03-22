import 'package:beebusy_app/service/SizeConfig.dart';
import 'package:beebusy_app/ui/widgets/bottom_navigation_bar.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_appbar.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
   MyScaffold({
    @required this.body,
    this.fab,
    this.showActions = false,
     this.drawer,
     this.key
  });

   GlobalKey<ScaffoldState> key;

   Widget drawer = Container();

   Widget fab = Container();

  final Widget body;
  final bool showActions;






  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    MySize().init(context);
    return Scaffold(
      key: key,
      appBar: MyAppBar(
        showActions: showActions,
      ),
      bottomNavigationBar: width < 600
          ? MyBottomNavigationBar()
          : null,
      drawer: drawer,
      floatingActionButton: fab,
      body: body,
    );
  }
}
