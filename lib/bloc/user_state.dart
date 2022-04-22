part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserSuccess extends UserState {
  final DataUser user;

  const UserSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}