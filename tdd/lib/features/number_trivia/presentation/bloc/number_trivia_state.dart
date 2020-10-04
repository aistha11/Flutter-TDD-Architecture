part of 'number_trivia_bloc.dart';

@freezed
abstract class NumberTriviaState with _$NumberTriviaState {
  const factory NumberTriviaState.initial() = _Initial;
}
