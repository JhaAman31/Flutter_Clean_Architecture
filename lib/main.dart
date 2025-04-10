import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/internet/connection_checker.dart';
import 'feature/product/data/data_source/product_data_source.dart';
import 'feature/product/data/data_source/product_local_data_source.dart';
import 'feature/product/data/repositories/product_repository_impl.dart';
import 'feature/product/domain/repositories/product_repositoy.dart';
import 'feature/product/domain/usecases/get_product_use_case.dart';
import 'feature/product/presentation/bloc/product_bloc.dart';


final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnection());

  // Register core services
  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductDataSource>(
    () => ProductDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl()),
  );

  // Register Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      connectionChecker: sl(),
      localDataSource: sl(),
      productDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProductUseCase(productRepository: sl()));

  // BLoC
  sl.registerFactory(() => ProductBloc(getProductUseCase: sl()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: HomePage(),
    );
  }
}
