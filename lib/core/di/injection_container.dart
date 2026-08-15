import 'package:dio/dio.dart';
import 'package:ecomm/core/config/app_config.dart';
import 'package:ecomm/core/database/app_database.dart';
import 'package:ecomm/core/network/auth_interceptor.dart';
import 'package:ecomm/core/network/network_info.dart';
import 'package:ecomm/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecomm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecomm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecomm/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecomm/features/auth/domain/usecases/get_user_profile.dart';
import 'package:ecomm/features/auth/domain/usecases/login_user.dart';
import 'package:ecomm/features/auth/domain/usecases/logout_user.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomm/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:ecomm/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomm/features/products/data/datasources/product_local_data_source.dart';
import 'package:ecomm/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecomm/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecomm/features/products/domain/repositories/product_repository.dart';
import 'package:ecomm/features/products/presentation/bloc/category_bloc.dart';
import 'package:ecomm/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //!Features - Auth
  //!External
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  //Core
  sl.registerLazySingleton(() => AuthInterceptor(authLocalDataSource: sl()));

  // Use Case
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  //Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      logoutUser: sl(),
      localDataSource: sl(),
      database: sl(),
    ),
  );

  //Use Cases (LazySingleton: only one instance needed for the logic)
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  //Repository (Implementation)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: sl()),
  );

  //DIO CONFIGURATION
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = AppConfig.instance.apiBaseUrl;

    // This is where the magic happens: Add the security guard!
    dio.interceptors.add(sl<AuthInterceptor>());

    // Optional: Add a logger to see requests in the console
    if (AppConfig.instance.enableDioLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          responseBody: true,
          requestBody: true,
        ),
      );
    }

    return dio;
  });

  //! Features - Products
  final database = AppDatabase();
  sl.registerSingleton<AppDatabase>(database);

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(database: sl()),
  );

  // External
  sl.registerLazySingleton(() => InternetConnection());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );

  // Bloc
  sl.registerFactory(() => ProductBloc(repository: sl()));

  sl.registerLazySingleton(() => CartBloc());

  sl.registerFactory(() => CategoryBloc(repository: sl()));

  sl.registerFactory(() => ProfileBloc(getUserProfile: sl()));
}
