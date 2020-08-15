import 'dart:convert';
import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFailure400() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('get concrete number trivia from remote data source', () {
    final int tNumber = 1;
    test(
        'should perform a GET request on URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      //act
      await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200(success)',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      //act
      final NumberTriviaModel result =
          await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(
          result,
          equals(
              NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')))));
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      setupMockHttpClientFailure400();
      //act
      final Function call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  // Random Number Trivia test

  group('get random number trivia from remote data source', () {
    test(
        'should perform a GET request on URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      //act
      await dataSource.getRandomNumberTrivia();
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200(success)',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      //act
      final NumberTriviaModel result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(
          result,
          equals(
              NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')))));
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      setupMockHttpClientFailure400();
      //act
      final Function call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
