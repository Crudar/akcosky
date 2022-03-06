import 'dart:math';

import 'package:akcosky/models/User.dart';
import 'package:akcosky/resources/Database.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:conduit_password_hash/pbkdf2.dart';
import 'package:conduit_password_hash/salt.dart';
import '../../Helpers/VerificationCodeSender.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  String username = "";
  String email = "";
  String pass = "";
  String verificationCode = "";

  Future<void> authenticate(String username_, String email_, String pass_) async {
    username = username_;
    email = email_;
    pass = pass_;

    //generate verification code
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    verificationCode = code.toString();

    bool response = await VerificationCodeSender.Send(email, verificationCode);

    if(response)
      emit(RegisterAuthenticate());
    else{
      emit(RegisterError("message"));
    }
  }

  void checkVerificationCode(String verificationCodeInput){
    if(verificationCodeInput == verificationCode){
      register();
    }
    else{
      emit(AuthenticateError());
    }
  }

  Future<void> register() async{
    // TODO - check if username is available - scan with username (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    // TODO - check if email is not used - scan with email (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    emit(RegisterLoading());

    Database db = await Database.create();

    var uuid = const Uuid();
    var id_ = uuid.v4();

    var generator = PBKDF2();
    var passSalt_ = Salt.generateAsBase64String(24);
    
    var passHash_ = generator.generateBase64Key(pass, passSalt_, 10101, 24);

    bool response = await db.addUserToDatabase(id_, username, email, passHash_, passSalt_);

    if(response)
      emit(RegisterSuccess());
    else {
      emit(RegisterError("Nemožno vytvoriť užívateľa. Si pripojený na internet?"));
    }
  }
}
