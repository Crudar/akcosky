import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:conduit_password_hash/pbkdf2.dart';
import 'package:conduit_password_hash/salt.dart';
import '../../resources/RegisterRepository.dart';

part 'registerfinal_state.dart';

class RegisterFinalCubit extends Cubit<RegisterFinalState> {
  final RegisterRepository _registerRepository;

  RegisterFinalCubit(this._registerRepository) : super(RegisterFinalInitial());

  Future<void> register() async {
    // TODO - check if username is available - scan with username (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    // TODO - check if email is not used - scan with email (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    emit(RegisterFinalLoading());

    var uuid = const Uuid();
    var id_ = uuid.v4();

    var generator = PBKDF2();
    var passSalt_ = Salt.generateAsBase64String(24);

    var passHash_ = generator.generateBase64Key(
        _registerRepository.password, passSalt_, 10101, 24);

    _registerRepository.id = id_;
    _registerRepository.passSalt_ = passHash_;
    _registerRepository.password = passHash_;

    bool response = await _registerRepository.addUser();

    if (response)
      emit(RegisterFinalSuccess());
    else {
      emit(RegisterFinalError("Nemožno vytvoriť užívateľa. Si pripojený na internet?"));
    }
  }

  void checkVerificationCode(String verificationCodeInput) {
    if (verificationCodeInput == _registerRepository.verificationCode) {
      register();
    }
    else {
      emit(RegisterFinalError("Chybný verifikačný kód. Skontroluj či si ho zadal správne."));
    }
  }
}
