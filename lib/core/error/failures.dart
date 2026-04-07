import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// 1. For API/Server issues
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server Error occurred'])
    : super(message);
}

// 2. For Local Database/Cache issues
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache Error occurred'])
    : super(message);
}

// 3. For No Internet issues
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No Internet Connection'])
    : super(message);
}
