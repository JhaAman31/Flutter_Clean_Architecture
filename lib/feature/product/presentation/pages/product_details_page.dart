import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/feature/product/domain/entities/product_entity.dart';
import 'package:flutter_clean_architecture/feature/product/presentation/widgets/detail_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.thumbnail ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DetailWidget(label: 'Title', value: product.title),
            DetailWidget(label: 'Description', value: product.description),
            DetailWidget(
              label: 'Price',
              value: '\$${product.price.toStringAsFixed(2)}',
            ),
            DetailWidget(
              label: 'Discount',
              value: '${product.discountPercentage}%',
            ),
            DetailWidget(label: 'Rating', value: product.rating.toString()),
            DetailWidget(label: 'Stock', value: product.stock.toString()),
            DetailWidget(label: 'Brand', value: product.brand ?? 'N/A'),
            DetailWidget(label: 'Category', value: product.category ?? 'N/A'),
            const SizedBox(height: 16),
            const Text(
              'Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: product.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Container(color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
