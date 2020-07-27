import 'dart:convert';

import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  final NumberTriviaModel numberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

  group('get last cached trivia model from local data source', () {
    test(
        'should get number trivia from shared preferences when there is cached data',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(numberTriviaModel));
    });

    test('should throw cache exception when there is no cached data', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cache numberTrivia to sharedPreference', () {
    NumberTriviaModel numberTriviaModel =
        NumberTriviaModel(text: 'Test Text', number: 1);
    test('should cache numberTrivia instance to sharedPreference', () async {
      //act
      dataSource.cacheNumberTrivia(numberTriviaModel);
      // assert
      final expectedJsonString = json.encode(numberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
