import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/feature/product/domain/entities/product_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProduct();
}
