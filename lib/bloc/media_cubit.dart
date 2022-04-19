import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {

  // service here

  MediaCubit() : super(const MediaInitial());

  Future<void> loadMedia() async {
    emit(const MediaLoading());

    // Simulated API/service call
    await Future.delayed(const Duration(seconds: 4));

    // Simulated success/error
    final success = false;

    if (success) {
      emit(const MediaSuccess( ["Media 1"] ));
    } else {
      //if toast,
        emit(const MediaError("Failed to load Media"));
        // then delay back to initial
      //else stay
    }
  }
}
