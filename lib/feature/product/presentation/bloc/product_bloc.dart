import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_use_case.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase getProductUseCase;

  ProductBloc({required this.getProductUseCase}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final Either<Failure, List<ProductEntity>> failureOrProducts =
    await getProductUseCase();
    failureOrProducts.fold(
          (failure) => emit(ProductError(message: failure.errorMessage)),
          (products) => emit(ProductLoaded(products: products)),
    );
  }
}
