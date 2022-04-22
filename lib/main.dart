import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_cast_md_examples/bloc/user_cubit.dart';
import 'package:global_cast_md_examples/services/api_dio.dart';
import 'package:global_cast_md_examples/services/api_service.dart';
import 'package:global_cast_md_examples/services/user_service.dart';

import 'bloc/media_cubit.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MediaCubit()),
        BlocProvider(create: (_) => UserCubit(UserService(ApiService(ApiDio()))))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}