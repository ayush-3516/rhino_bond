import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    required this.scaffoldKey,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use platform-specific styling
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: SvgPicture.asset(
          'lib/assets/logo.svg',
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

    return Container(
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SvgPicture.asset(
            'lib/assets/logo.svg',
            height: 36,
            colorFilter: const ColorFilter.mode(
              Color(0xFF00008B), // Dark blue color
              BlendMode.srcIn,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
