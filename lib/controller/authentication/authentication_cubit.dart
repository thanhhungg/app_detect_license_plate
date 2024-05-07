import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../services/authentication_service.dart';

part 'authentication_state.dart';
part 'authentication_cubit.freezed.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState.initial());
  AuthenticationRepositoryImpl authRepository =
      GetIt.instance.get<AuthenticationRepositoryImpl>();

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthenticationState.loading());
      UserCredential userCredential = await authRepository.signInWithGoogle();
      emit(AuthenticationState.success(userCredential));
    } catch (error) {
      emit(AuthenticationState.error(error.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(const AuthenticationState.loading());
      await authRepository.logout();
      emit(const AuthenticationState.logOutSuccess());
    } catch (error) {
      emit(AuthenticationState.error(error.toString()));
    }
  }
}
