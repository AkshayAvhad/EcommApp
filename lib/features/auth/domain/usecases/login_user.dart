import 'package:dartz/dartz.dart';
import 'package:ecomm/core/error/failures.dart';
import 'package:ecomm/features/auth/domain/entities/user.dart';
import 'package:ecomm/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User>> execute(String username, String password) {
    return repository.login(username, password);
  }
}
