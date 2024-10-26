import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/domain/entity/app_user.dart';
import 'package:mysnap/features/auth/domain/repository/auth_repository.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  // check if the user authenticated
  void checkAuth() async {
    final AppUser? user = await authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  // get curr user
  AppUser? get currentUser => _currentUser;

  //login with email passsword
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepository.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  // register with email password
  Future<void> register(String email, String password, String name) async{
    try {
      emit(AuthLoading());
      final user = await authRepository.registerWithEmailPassword(email, password, name);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  // logout
  Future<void> logout() async{
    authRepository.logout();
    emit(UnAuthenticated());
  }
}
