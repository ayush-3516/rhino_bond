// ignore: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use platform-specific styling
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: SvgPicture.asset(
          'assets/logo.svg',
          height: 36,
          colorFilter: ColorFilter.mode(
            CupertinoTheme.of(context).primaryColor,
            BlendMode.srcIn,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(CupertinoIcons.line_horizontal_3),
        ),
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
        border: null,
      );
    }

    return AppBar(
      automaticallyImplyLeading: false, // This removes the left burger button
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset(
          'assets/logo.svg',
          height: 36,
          colorFilter: ColorFilter.mode(
            Theme.of(context).primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      ],
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
