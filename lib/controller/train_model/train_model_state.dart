part of 'train_model_cubit.dart';

@freezed
class TrainModelState with _$TrainModelState {
  const factory TrainModelState.initial() = _Initial;

  const factory TrainModelState.loading() = _Loading;

  const factory TrainModelState.success(List<ModelResultDto> data) = _Success;

  const factory TrainModelState.error(dynamic error) = _Error;
}
