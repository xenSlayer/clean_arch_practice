import 'package:clean_arch/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw FormatException();
      } else {
        return Right(integer);
      }
    } on FormatException {
      return Left(InvalidInputFailures());
    }
  }
}

class InvalidInputFailures extends Failure {}
