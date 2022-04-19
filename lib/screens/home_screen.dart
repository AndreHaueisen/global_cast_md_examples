import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_cast_md_examples/bloc/media_cubit.dart';

import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // context.read<MediaCubit>().loadMedia();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormScreen()),
              );
            },
            child: const Text("call state change"),
          ),
          BlocConsumer<MediaCubit, MediaState>(
            builder: (_, state) { // Basically from BlocBuilder
              if (state is MediaInitial) {
                return buildInitialWidget();
              }

              if (state is MediaLoading) {
                return buildLoadingWidget();
              }

              if (state is MediaSuccess) {
                return buildSuccessWidget(state);
              }

              if (state is MediaError) {
                return buildErrorWidget(state);
              }

              throw Exception("Illegal MediaState: $state");
            },
            listener: (_, state) { // Basically from BlocListener
              if (state is MediaError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                ));
                // show toast
              }
            }
          ),
        ],
      ),
    );
  }

  Widget buildInitialWidget() {
    return const Text("Initial");
  }

  Widget buildLoadingWidget() {
    return const CircularProgressIndicator();
  }

  Widget buildSuccessWidget(MediaSuccess state) {
    return Text(state.media[0]);
  }

  Widget buildErrorWidget(MediaError state) {
    return Text(state.errorMessage);
  }

}
