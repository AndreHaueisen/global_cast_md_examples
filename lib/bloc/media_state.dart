part of 'media_cubit.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object> get props => [];
}

class MediaInitial extends MediaState {
  const MediaInitial();
}

class MediaLoading extends MediaState {
  const MediaLoading();
}

class MediaSuccess extends MediaState {
  final List<String> media;

  const MediaSuccess(this.media);

  @override
  List<Object> get props => [media];
}

class MediaError extends MediaState {
  final String errorMessage;

  const MediaError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}