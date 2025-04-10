import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_clean_architecture/core/internet/connection_checker.dart';
import 'package:flutter_clean_architecture/feature/product/data/data_source/product_data_source.dart';
import 'package:flutter_clean_architecture/feature/product/data/data_source/product_local_data_source.dart';
import 'package:flutter_clean_architecture/feature/product/data/models/product_model.dart';
import 'package:flutter_clean_architecture/feature/product/domain/repositories/product_repositoy.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;
  final ProductLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  ProductRepositoryImpl({
    required this.productDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<ProductModel>>> getProduct() async {
    if (await connectionChecker.isConnected) {
      try {
        print(
          "Connected to Internet: ${await connectionChecker.isConnected}",
        );
        final productList = await productDataSource.getProducts();
        await localDataSource.cacheProducts(productList);
        return Right(productList);
      } on ServerException {
        return Left(ServerFailure(errorMessage: "Something might went wrong"));
      }
    } else {
      try {
        final cacheProduct = await localDataSource.getCachedProducts();

        return Right(cacheProduct);
      } on CacheException {
        print("No internet & no cache found.");
        return Left(ConnectionFailure(errorMessage: "No internet connection"));
        // add this
      }
    }
  }
}
