import 'package:ecomm/features/auth/domain/usecases/get_user_profile.dart';
import 'package:ecomm/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:ecomm/features/auth/presentation/bloc/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;

  ProfileBloc({required this.getUserProfile}) : super(ProfileInitial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
  }

  void _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getUserProfile.execute();

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileLoaded(user: user)),
    );
  }
}
