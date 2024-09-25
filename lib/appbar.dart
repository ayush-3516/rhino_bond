// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myAppBar(String title) {
  return AppBar(
    backgroundColor: const Color.fromRGBO(156, 204, 101, 1),
    //background color of Appbar to green
    title: Text(title),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          //action for search icon button
        },
      ),
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          //action for user icon button
        },
      )
    ],
  );
}
