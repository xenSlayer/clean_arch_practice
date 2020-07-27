import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repositories.dart';

// Implemented with class UseCase so that we don't forget to write call() method in every usecase
class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  NumberTriviaRepository numberTriviaRepository;

  /// https://www.api.com/42 -> For concrete number trivia
  ///
  /// https://www.api.com/random -> For random number trivia
  GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async =>
      await numberTriviaRepository.getConcreteNumberTrivia(params.number);
}

/// Parameters ie. int. If no parameter then use [NoParams]
class Params extends Equatable {
  final int number;

  Params({@required this.number});
  @override
  List get props => [number];
}
