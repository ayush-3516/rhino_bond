import 'package:flutter/material.dart';
import 'package:rhino_bond/app_drawer.dart';
import 'package:rhino_bond/appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[100],
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: myAppBar("Home Page")),
        //set app bar from appbar.dart
        // use like this where ever you want
        drawer: myDrawer(),
        //set drawer from app_drawer.dart
        //set like this where ever you want
        body: const Center(
            child: Text(
          "Reusable Drawer and Appbar",
          style: TextStyle(fontSize: 20),
        )));
  }
}
