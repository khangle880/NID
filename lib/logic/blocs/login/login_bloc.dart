// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../repositories/user_repository.dart';
import '../../utils/errors/auth_error.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {required String email, required String password}) async* {
    yield LoginLoading();
    final String? error =
        await _userRepository.signInWithCredentials(email, password);
    if (error == null) {
      yield LoginSuccess();
    } else {
      yield LoginFailure(error);
    }
  }
}
