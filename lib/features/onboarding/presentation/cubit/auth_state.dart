part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;

  const factory AuthState.loading() = Loading;

  const factory AuthState.authenticated({
    required User firebaseUser,
    required AppUser appUser,
    required bool isNewUser,
  }) = Authenticated;

  const factory AuthState.error({required String message}) = Error;
}
