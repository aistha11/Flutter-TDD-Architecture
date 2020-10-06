part of 'number_trivia_bloc.dart';

// @freezed
// abstract class NumberTriviaEvent with _$NumberTriviaEvent {
//   const factory NumberTriviaEvent.getTriviaForConcreteNumber(String numberString) = GetTriviaForConcreteNumber;
//   const factory NumberTriviaEvent.getTriviaForRandomNumber() = GetTriviaForRandomNumber;
// }

@immutable
abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}