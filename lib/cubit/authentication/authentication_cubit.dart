import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationUnAuthenticated());

  //TODO - check if user is authenticated (if userdata are in local storage)
}
