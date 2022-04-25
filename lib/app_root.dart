import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_cast_md_examples/app_config.dart';
import 'package:global_cast_md_examples/app_router.dart';
import 'package:global_cast_md_examples/bloc/user_cubit.dart';

import 'bloc/media_cubit.dart';
import 'screens/home_screen.dart';

class AppRoot extends StatelessWidget {

  final AppConfig appConfig;

  const AppRoot({Key? key, required this.appConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MediaCubit()),
        BlocProvider(create: (_) => UserCubit(appConfig.userService)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: onGenerateRoute,
        // initialRoute: '/',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}