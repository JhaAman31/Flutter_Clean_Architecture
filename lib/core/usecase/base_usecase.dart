import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BaseUseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
