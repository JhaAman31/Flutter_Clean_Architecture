import 'dart:convert';

import 'package:flutter_clean_architecture/core/constant/constants.dart';
import 'package:flutter_clean_architecture/core/error/server_exception.dart';
import 'package:flutter_clean_architecture/feature/product/data/models/product_model.dart';
import 'package:http/http.dart' as http;

abstract interface class ProductDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductDataSourceImpl extends ProductDataSource {
  final http.Client client;

  ProductDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse(Constants.PRODUCT_BASE_URL);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        List<dynamic> productData = data["products"];

        return productData
            .map((myData) => ProductModel.fromJson(myData))
            .toList();
      } catch (e) {
        print("JSON Parse Error: $e");
        throw ServerException();
      }
    } else {
      print("Server returned error status: ${response.statusCode}");
      throw ServerException();
    }
  }
}
