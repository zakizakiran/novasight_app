import 'package:equatable/equatable.dart';

sealed class UiState<T> extends Equatable {
  const UiState();

  @override
  List<Object?> get props => [];
}

class UiStateInitial<T> extends UiState<T> {
  const UiStateInitial();
}

class UiStateLoading<T> extends UiState<T> {
  const UiStateLoading();
}

class UiStateFailure<T> extends UiState<T> {
  final String error;

  const UiStateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UiStateSuccess<T> extends UiState<T> {
  final T data;

  const UiStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}