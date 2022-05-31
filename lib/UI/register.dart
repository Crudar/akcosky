import 'package:akcosky/UI/validation_components/EmailInputWidget.dart';
import 'package:akcosky/UI/validation_components/PasswordAgainInputWidget.dart';
import 'package:akcosky/UI/validation_components/PasswordInputWidget.dart';
import 'package:akcosky/UI/validation_components/UsernameInputWidget.dart';
import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:akcosky/models/validation/EmailInput.dart';
import 'package:akcosky/models/validation/StringInput.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import '../cubit/registerstart/registerstart_cubit.dart';
import '../models/validation/PasswordAgainInput.dart';
import '../resources/RegisterRepository.dart';
import '../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatelessWidget {
  final RegisterRepository _registerRepository = RegisterRepository();

  Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<ValidationElement, FormzInput> input = {
      ValidationElement.email: EmailInput.pure(""),
      ValidationElement.username: StringInput.pure(""),
      ValidationElement.password: StringInput.pure(""),
      ValidationElement.passwordAgain: PasswordAgainInput.pure("")
    };

    return RepositoryProvider.value(
        value: _registerRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RegisterStartCubit>(
              create: (context) => RegisterStartCubit(registerRepository: _registerRepository),
            ),
            BlocProvider<ValidationCubit>(
              create: (BuildContext context) => ValidationCubit(inputsMap: input),
            )
          ],
          child: RegisterForm(),
        )
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterForm>{
  bool passwordNotShown = true;
  bool passwordAgainNotShown = true;

  var email = TextEditingController();
  var login = TextEditingController();
  var password = TextEditingController();
  var password_again = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordAgainFocusNode = FocusNode();

  //final _emailRawKeyboard = RawKeyboardListener(focusNode: _emailFocusNode, child: SizedBox.shrink());

  showPassword() {
    setState(() {
      passwordNotShown = !passwordNotShown;
    });
  }

  showAgainPassword(){
    setState(() {
      passwordAgainNotShown = !passwordAgainNotShown;
    });
  }

  //final RegisterRepository _registerRepository = RegisterRepository();



  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<ValidationCubit>().onEmailUnfocused();
        //FocusScope.of(context).requestFocus(_usernameFocusNode);
      }
    });

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        context.read<ValidationCubit>().onUsernameUnfocused();
        //FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<ValidationCubit>().onPasswordUnfocused();
        //FocusScope.of(context).requestFocus(_passwordAgainFocusNode);
      }
    });
    _passwordAgainFocusNode.addListener(() {
      if (!_passwordAgainFocusNode.hasFocus) {
        context.read<ValidationCubit>().onPasswordAgainUnfocused();

        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordAgainFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff240b36),
                  Color(0xffc31432)
                  ]
                )
              ),
            child: BlocConsumer<RegisterStartCubit, RegisterStartState>(
                listener: (context, state) {
                  if(state is RegisterStartAuthenticate){
                    Navigator.pushNamed(context, '/registerfinal', arguments: RepositoryProvider.of<RegisterRepository>(context));
                  }
                },
                builder: (context, state) {
                  if(state is RegisterStartInitial){
                    return buildInitialRegisterForm();
                  }
                  else if(state is RegisterStartLoading){
                    //TODO LOADING
                    return buildInitialRegisterForm();
                  }
                  else{
                    return buildInitialRegisterForm();
                  }
                }
            )
        )
    );
  }

  Widget buildInitialRegisterForm(){
    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Text(
                  'Registrácia',
                  style: Theme_.lightTextTheme.headline1,
                  textAlign: TextAlign.center,
                )
              )
            ),
              const SizedBox(
                height: 25,
              ),
              EmailInputWidget(focusNode: _emailFocusNode),
              const SizedBox(
                height: 25,
              ),
              UsernameInputWidget(focusNode: _usernameFocusNode),
              const SizedBox(
                height: 25,
              ),
              PasswordInputsWidget(focusNodePassword1: _passwordFocusNode, focusNodePassword2: _passwordAgainFocusNode),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: SubmitButtonWidget()
                  )
              )
            ],
          ),
      ),
    );
  }
}

class PasswordInputsWidget extends StatelessWidget{
  const PasswordInputsWidget({Key? key, required this.focusNodePassword1, required this.focusNodePassword2}) : super(key: key);

  final FocusNode focusNodePassword1;
  final FocusNode focusNodePassword2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      builder: (context, state) {
        return Column(
          children: [
            PasswordInputWidget(focusNode: focusNodePassword1, passwordAgain: true),
            const SizedBox(
              height: 25,
            ),
            PasswordAgainInputWidget(focusNode: focusNodePassword2)
          ],
        );
      }
    );
  }
}

class SubmitButtonWidget extends StatelessWidget{
  const SubmitButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
        //buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state){
          return ElevatedButton(
            onPressed: context.read<ValidationCubit>().status.isValidated
            ? () => BlocProvider.of<RegisterStartCubit>(context).authenticate(context.read<ValidationCubit>().inputsMap[ValidationElement.username]?.value,
                context.read<ValidationCubit>().inputsMap[ValidationElement.email]?.value,
                context.read<ValidationCubit>().inputsMap[ValidationElement.password]?.value)
                : null,
            child: const Icon(FontAwesomeIcons.arrowRight),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                primary: Color(0xff000428), // <-- Button color
                onSurface: Colors.black,
                onPrimary: Colors.white, // <-- Splash color
              )
          );
      }
    );
  }
}
/*
String? validateEmail(String? input){
  if (input == null || input.isEmpty) {
    return 'Prosím zadaj e-mail';
  }
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);

  if(!emailValid){
    return 'Prosím zadaj platný e-mail';
  }

  return null;
}

String? validateEmpty(String? input, String inputName){
  if (input == null || input.isEmpty) {
    return 'Prosím vyplň ' + inputName;
  }
  return null;
}

String? validatePasswordCheck(String? password1, String? password2, String inputName){
  if (password1 == null || password1.isEmpty) {
    return 'Prosím vyplň ' + inputName;
  }

  if(password1 != password2){
    return 'Heslá nie sú rovnaké';
  }

  return null;
}*/