import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd/core/error/exception.dart';
import 'package:tdd/features/number_trivia/data/dataSources/number_trivia_local_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNUmberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange

        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));

        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNUmberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cache value',
      () async {
        // arrange

        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test Trivia');
    test('should call sharedPreferences to cache the data', () async {
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
