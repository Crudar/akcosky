import 'package:akcosky/resources/AuthenticationRepository.dart';
import 'package:akcosky/resources/UserRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:conduit_password_hash/pbkdf2.dart';
import '../../models/Domain/UserDomain.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.authenticationRepository, required this.userRepository}) : super(AuthenticationUnAuthenticated());

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  void login(String username, String password) async{
    UserDomain? userDomain = await authenticationRepository.logIn(username: username, password: password);

    var generator = PBKDF2();

    var passHash_input = generator.generateBase64Key(
        password, userDomain?.passwordSalt ?? "", 10101, 24);

    String passHash_fromDb = userDomain?.passwordHash ?? "";

    /*var passHash_fromDb = generator.generateBase64Key(
        userDomain?.passwordHash ?? "", userDomain?.passwordSalt ?? "", 10101, 24);*/

    if(passHash_input == passHash_fromDb){
      emit(AuthenticationAuthenticated());
    }
    else{
      emit(AuthenticationUnAuthenticated());
    }
  }

  //TODO - check if user is authenticated (if userdata are in local storage) - something like this - https://bloclibrary.dev/#/flutterlogintutorial?id=authentication-repository
}
