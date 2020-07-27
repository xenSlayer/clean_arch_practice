import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/network/network_info.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final int tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel(text: 'Test text', number: tNumber);

  final NumberTrivia tNumberTrivia = tNumberTriviaModel;

  group('Get concerete NumberTrivia', () {
    test('should check if the device is connected to the internet or not',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('Device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTriviaModel)));
    });

    test(
        'should cache data locally when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });

    test(
        'should return server faiures when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('Device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test('should return last locally cached data from local source', () async {
      // arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('should return cacheFailure if there is no cached data present',
        () async {
      // arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure())));
    });
  });

  // Random Number Trivia Tests
  group('Get random NumberTrivia', () {
    test('should check if the device is connected to the internet or not',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('Device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getRandomNumberTrivia();
      // assert
      verify(mockRemoteDataSource.getRandomNumberTrivia());
      expect(result, equals(Right(tNumberTriviaModel)));
    });

    test(
        'should cache data locally when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      await repository.getRandomNumberTrivia();
      // assert
      verify(mockRemoteDataSource.getRandomNumberTrivia());
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });

    test(
        'should return server faiures when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());
      //act
      final result = await repository.getRandomNumberTrivia();
      // assert
      verify(mockRemoteDataSource.getRandomNumberTrivia());
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('Device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test('should return last locally cached data from local source', () async {
      // arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getRandomNumberTrivia();
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('should return cacheFailure if there is no cached data present',
        () async {
      // arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
      //act
      final result = await repository.getRandomNumberTrivia();
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
