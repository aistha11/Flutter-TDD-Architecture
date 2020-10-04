part of 'number_trivia_bloc.dart';

@freezed
abstract class NumberTriviaEvent with _$NumberTriviaEvent {
  const factory NumberTriviaEvent.started() = _Started;
}