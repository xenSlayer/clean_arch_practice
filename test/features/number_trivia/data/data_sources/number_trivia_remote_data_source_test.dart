import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
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

  group('get concrete number trivia from remote data source', () {
    final int tNumber = 1;
    test(
        'should perform a GET request on URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });
  });
}
