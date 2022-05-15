import 'dart:convert';
import 'package:akcosky/models/User.dart';
import 'package:akcosky/resources/AuthenticationRepository.dart';
import 'package:akcosky/resources/UserRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:meta/meta.dart';
import '../../models/Database/UserDatabase.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.authenticationRepository, required this.userRepository}) : super(AuthenticationUnAuthenticated());

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  void login(String username, String password) async{
    UserDatabase? userDomain = await authenticationRepository.logIn(username: username, password: password);

    Salt salt = Salt(base64Decode(userDomain?.passwordSalt ?? ""));

    var passHashInput = await argon2.hashPasswordString(password, salt: salt);
    String passHashInputBase64 = passHashInput.base64String;

    String passHashFromDb = userDomain?.passwordHash ?? "";

    if(passHashInputBase64 == passHashFromDb){
      if(userDomain != null) {
        userRepository.setUser(User(userDomain.id, userDomain.login, userDomain.email, userDomain.groups));
      }

      emit(AuthenticationAuthenticated());
    }
    else{
      emit(AuthenticationUnAuthenticated());
    }
  }

  //TODO - check if user is authenticated (if userdata are in local storage) - something like this - https://bloclibrary.dev/#/flutterlogintutorial?id=authentication-repository
}
