import 'dart:async';

import 'package:flutter/material.dart';
import 'package:global_cast_md_examples/app_config.dart';

import 'app_root.dart';

void main() async {

  runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Services
    final appConfig = AppConfig()..initialize();

    // Async initialization calls here

    return runApp(AppRoot(appConfig: appConfig));
  }, (error, stackTrace) {
    // handle errors (Crashlytics, etc)
  });
}