part of 'detect_cubit.dart';

@freezed
class DetectState with _$DetectState {
  const factory DetectState.initial() = _Initial;

  const factory DetectState.loading() = _Loading;

  const factory DetectState.success(List<LicensePlateResult> data) = _Success;
  const factory DetectState.successModel(List<ModelResultDto> data) =
      SuccessModel;

  const factory DetectState.error(dynamic error) = _Error;
}
