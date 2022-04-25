import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:global_cast_md_examples/screens/home_screen.dart';

import 'screens/form_screen.dart';

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return _getPageRoute(screen: HomeScreen(), settings: settings);
    case FormScreen.routeName:
      return _getPageRoute(screen: const FormScreen(), settings: settings);
  }
}

PageRoute _getPageRoute({required Widget screen, RouteSettings? settings}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (_) => screen, settings: settings);
  } else {
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}