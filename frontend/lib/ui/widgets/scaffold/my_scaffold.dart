import 'package:beebusy_app/service/SizeConfig.dart';
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

    MySize().init(context);
    return Scaffold(
      key: key,
      ///todo: i've commented because of appbar
      // appBar: MyAppBar(
      //   showActions: showActions,
      // ),
      //

     drawer: drawer,
      floatingActionButton: fab,
      body: body,
    );
  }
}
