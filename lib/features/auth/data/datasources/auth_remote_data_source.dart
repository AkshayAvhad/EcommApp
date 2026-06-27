import 'package:dio/dio.dart';
import 'package:ecomm/core/error/failures.dart';
import 'package:ecomm/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);

  Future<UserModel> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'username': username, 'password': password, 'expiresInMins': 60},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerFailure();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerFailure('Invalid username or password');
      }
      throw ServerFailure();
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await dio.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data, fallbackToken: '');
      } else {
        throw ServerFailure();
      }
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message']);
    }
  }
}
