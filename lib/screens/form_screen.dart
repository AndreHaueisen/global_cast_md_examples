import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_cast_md_examples/bloc/form_cubit.dart' as ex;

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  @override
  void initState() {
    super.initState();

    // Causes error, Provider non-existent at this level in tree
    // context.read<ex.FormCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ex.FormCubit(),
      child: Scaffold(
        body: Container(
          child: BlocBuilder<ex.FormCubit, ex.FormState>(
            builder: (_, state) {
              if (state is ex.FormInitial) {
                return const Center(
                  child: const Text("Testing Text"),
                );
              }
              throw Exception("Invalid state $state");
            },
          ),
        ),
      ),
    );
  }
}
