part of 'manage_cubit.dart';

@freezed
class ManageState with _$ManageState {
  const factory ManageState.initial() = _Initial;

  const factory ManageState.loading() = _Loading;

  const factory ManageState.success(List<SampleDto> data) = _Success;

  const factory ManageState.error(dynamic error) = _Error;
}
