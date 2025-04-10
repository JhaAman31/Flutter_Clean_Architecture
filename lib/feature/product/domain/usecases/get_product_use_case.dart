import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/usecase/base_usecase.dart';
import 'package:flutter_clean_architecture/feature/product/domain/entities/product_entity.dart';
import 'package:flutter_clean_architecture/feature/product/domain/repositories/product_repositoy.dart';
import 'package:fpdart/src/either.dart';

class GetProductUseCase {
  final ProductRepository productRepository;

  GetProductUseCase({required this.productRepository});

  Future<Either<Failure, List<ProductEntity>>> call() {
    return productRepository.getProduct();
  }
}
