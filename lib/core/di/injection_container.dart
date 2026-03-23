import 'package:ecomm/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecomm/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecomm/features/products/domain/repositories/product_repository.dart';
import 'package:ecomm/features/products/presentation/bloc/product_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Products

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());

  // Bloc
  sl.registerFactory(() => ProductBloc(repository: sl()));
}
