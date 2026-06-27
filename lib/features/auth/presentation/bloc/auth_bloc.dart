import 'dart:async';

import 'package:ecomm/core/database/app_database.dart';
import 'package:ecomm/core/util/logout_event_helper.dart';
import 'package:ecomm/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecomm/features/auth/domain/entities/user.dart';
import 'package:ecomm/features/auth/domain/usecases/login_user.dart';
import 'package:ecomm/features/auth/domain/usecases/logout_user.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final AuthLocalDataSource localDataSource;
  final AppDatabase database;

  StreamSubscription? _logoutSubscription;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.localDataSource,
    required this.database,
  }) : super(AuthInitial()) {
    _logoutSubscription = LogoutEventHelper.logoutStream.listen((_) {
      add(LoggedOut());
    });

    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await localDataSource.getToken();
    if (token != null) {
      emit(Authenticated(user: _dummyUser(token)));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUser.execute(event.username, event.password);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await logoutUser.execute();
    try {
      await database.clearAllData();
    } catch (exception) {
      print("Database clear failed quietly: $exception");
    }
    emit(Unauthenticated());
  }

  User _dummyUser(String token) => User(
    id: 0,
    username: 'storedUser',
    email: '',
    firstName: '',
    lastName: '',
    gender: '',
    image: '',
    token: '',
  );

  @override
  Future<void> close() {
    _logoutSubscription?.cancel();
    return super.close();
  }
}
