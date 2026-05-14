import 'package:dartz/dartz.dart';
import 'package:ecomm/core/error/failures.dart';
import 'package:ecomm/features/auth/domain/entities/user.dart';

abstract class AuthRepository {

  Future<Either<Failure, User>> login(String username, String password);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isCheckLoggedIn();

  Future<Either<Failure, User>> getUserProfile();

}