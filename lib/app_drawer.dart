// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myDrawer() {
  return Drawer(
    child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () {
                      // Home button action
                    }),

                ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("My Profile"),
                    onTap: () {
                      // My Pfofile button action
                    }),

                ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text("Find Peoples"),
                    onTap: () {
                      // Find peoples button action
                    })

                //add more drawer menu here
              ],
            ))),
  );
}
