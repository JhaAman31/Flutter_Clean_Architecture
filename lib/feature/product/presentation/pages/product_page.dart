import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/feature/form/presentation/pages/form_page.dart';
import 'package:flutter_clean_architecture/feature/product/presentation/pages/product_details_page.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../domain/entities/product_entity.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Products',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial) {
            context.read<ProductBloc>().add(FetchProducts());
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return _buildProductList(context, state.products);
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<ProductEntity> products) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(FetchProducts()); // ✅ context works now
      },
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        itemCount: products.length,
        separatorBuilder:
            (context, index) =>
                const Divider(color: Colors.white12, thickness: 1, height: 0),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            leading: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.5),
              ),
              child: ClipOval(
                child: Image.network(
                  product.thumbnail ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(product.title),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
