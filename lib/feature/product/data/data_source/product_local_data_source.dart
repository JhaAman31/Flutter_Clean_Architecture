import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/constants.dart';
import '../../../../core/error/server_exception.dart';
import '../models/product_model.dart';

abstract interface class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences prefs;

  ProductLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheProducts(List<ProductModel> products) {
    final productJson = products.map((e) => e.toJson()).toList();
    return prefs.setString(Constants.PRODUCT_CACHE_KEY, jsonEncode(productJson));
  }

  @override
  Future<List<ProductModel>> getCachedProducts() {
    final jsonString = prefs.getString(Constants.PRODUCT_CACHE_KEY);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return Future.value(decoded.map((e) => ProductModel.fromJson(e)).toList());
    } else {
      throw CacheException();
    }
  }
}
