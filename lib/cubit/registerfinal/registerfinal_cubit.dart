import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import '../../resources/RegisterRepository.dart';

part 'registerfinal_state.dart';

class RegisterFinalCubit extends Cubit<RegisterFinalState> {
  final RegisterRepository _registerRepository;

  RegisterFinalCubit(this._registerRepository) : super(RegisterFinalInitial());

  Future<void> register() async {
    DArgon2Flutter.init();
    // TODO - check if username is available - scan with username (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    // TODO - check if email is not used - scan with email (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    emit(RegisterFinalLoading());

    var uuid = const Uuid();
    var id_ = uuid.v4();

    Salt passSalt = Salt.newSalt(length: 32);
    String passSaltBase64 = base64.encode(passSalt.bytes);

    var passHash = await argon2.hashPasswordString(_registerRepository.password,
        salt: passSalt);
    String passHashBase64 = passHash.base64String;

    _registerRepository.id = id_;
    _registerRepository.passSalt_ = passSaltBase64;
    _registerRepository.password = passHashBase64;

    bool response = await _registerRepository.addUser();

    if (response)
      emit(RegisterFinalSuccess());
    else {
      emit(RegisterFinalError(
          "Nemožno vytvoriť užívateľa. Si pripojený na internet?"));
    }
  }

  void checkVerificationCode(String verificationCodeInput) {
    if (verificationCodeInput == _registerRepository.verificationCode) {
      register();
    } else {
      emit(RegisterFinalError(
          "Chybný verifikačný kód. Skontroluj či si ho zadal správne."));
    }
  }
}
