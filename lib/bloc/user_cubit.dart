import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:global_cast_md_examples/services/user_service.dart';
import '../data/data_user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {

  final UserService userService;

  UserCubit(this.userService) : super(const UserInitial());

  Future<void> fetchUser() async {
    emit(const UserLoading());

    final result = await userService.fetchUser();

    if (result.isSuccess) {
      emit(UserSuccess(result.data!));
    } else {
      emit(UserError(result.errorMessage!));
    }
  }

}
