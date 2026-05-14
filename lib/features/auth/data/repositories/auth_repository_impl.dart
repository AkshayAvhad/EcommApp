import 'package:dartz/dartz.dart';
import 'package:ecomm/core/error/failures.dart';
import 'package:ecomm/core/network/network_info.dart';
import 'package:ecomm/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecomm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecomm/features/auth/domain/entities/user.dart';
import 'package:ecomm/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.login(username, password);

        await localDataSource.saveToken(userModel.token);

        return Right(userModel.toEntity());
      } catch (exception) {
        return const Left(ServerFailure('Invalid credentials or Server error'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isCheckLoggedIn() {
    // TODO: implement isCheckLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      return const Right(null);
    } catch (exception) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.getUserProfile();
        return Right(userModel.toEntity());
      } catch (e) {
        return const Left(ServerFailure('Could not fetch profile'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
