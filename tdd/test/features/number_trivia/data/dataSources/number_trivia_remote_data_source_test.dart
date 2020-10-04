import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tdd/core/error/exception.dart';
import 'package:tdd/features/number_trivia/data/dataSources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setMockHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setMockHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong',404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a Url with number being the endpoint and with application/header',
        () async {
      //arrange
        // when(mockHttpClient.get(any, headers: anyNamed('headers')))
        //     .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      setMockHttpClientSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test(
        'should return NumberTrivia when the response code is 200 (success)',
        () async {
      //arrange
        // when(mockHttpClient.get(any, headers: anyNamed('headers')))
        //     .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
        setMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result,equals(tNumberTriviaModel));

    });

    test(
        'should throw a Server Expection when the response code is 404 or other',
        () async {
      //arrange
        // when(mockHttpClient.get(any, headers: anyNamed('headers')))
        //     .thenAnswer((_) async => http.Response('Something went wrong',404));
        setMockHttpClientFailure404();
      //act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(()=>call(tNumber),throwsA(TypeMatcher<ServerException>()));

    });

  });

  group('getRandomNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a Url with number being the endpoint and with application/header',
        () async {
      //arrange
        // when(mockHttpClient.get(any, headers: anyNamed('headers')))
        //     .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      setMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test(
        'should return NumberTrivia when the response code is 200 (success)',
        () async {
      //arrange
        // when(mockHttpClient.get(any, headers: anyNamed('headers')))
        //     .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
        setMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result,equals(tNumberTriviaModel));

    });

    test(
        'should throw a Server Expection when the response code is 404 or other',
        () async {
      //arrange
        // when(mockHttpClient.get(any, headers: anyNamed('headers')))
        //     .thenAnswer((_) async => http.Response('Something went wrong',404));
        setMockHttpClientFailure404();
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(()=>call(),throwsA(TypeMatcher<ServerException>()));

    });

  });


}
