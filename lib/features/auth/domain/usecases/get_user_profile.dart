import 'package:dartz/dartz.dart';
import 'package:ecomm/core/error/failures.dart';
import 'package:ecomm/features/auth/domain/entities/user.dart';
import 'package:ecomm/features/auth/domain/repositories/auth_repository.dart';

class GetUserProfile {
  final AuthRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, User>> execute() {
    return repository.getUserProfile();
  }
}
