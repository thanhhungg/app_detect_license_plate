part of 'authentication_cubit.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = _Initial;

  const factory AuthenticationState.loading() = Loading;

  const factory AuthenticationState.success(dynamic data) = _Success;
  const factory AuthenticationState.logOutSuccess() = _LogOutSuccess;

  const factory AuthenticationState.error(dynamic error) = _Error;
}
