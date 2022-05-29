import 'package:akcosky/UI/email_verification.dart';
import 'package:akcosky/models/validation/PasswordAgainInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import '../cubit/registerstart/registerstart_cubit.dart';
import '../models/validation/EmailInput.dart';
import '../models/validation/StringInput.dart';
import '../resources/RegisterRepository.dart';
import '../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatelessWidget {
  final RegisterRepository _registerRepository = RegisterRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _registerRepository,
        child: BlocProvider(
        create: (context) => RegisterStartCubit(registerRepository: _registerRepository),
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
        context.read<RegisterStartCubit>().onEmailUnfocused();
        //FocusScope.of(context).requestFocus(_usernameFocusNode);
      }
    });

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        context.read<RegisterStartCubit>().onUsernameUnfocused();
        //FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<RegisterStartCubit>().onPasswordUnfocused();
        //FocusScope.of(context).requestFocus(_passwordAgainFocusNode);
      }
    });
    _passwordAgainFocusNode.addListener(() {
      if (!_passwordAgainFocusNode.hasFocus) {
        context.read<RegisterStartCubit>().onPasswordAgainUnfocused();
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
      //resizeToAvoidBottomInset: true,
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
            child: buildInitialRegisterForm()
        /*BlocConsumer<RegisterStartCubit, RegisterStartState>(
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
      )*/
        )
    );
  }

  Widget buildInitialRegisterForm(){
    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child:
          Expanded(
            child: SingleChildScrollView(child: Column(
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
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    controller: password,
                    validator: (value) => validateEmpty(value, "heslo"),
                    decoration: InputDecoration(
                        hintText: 'Zadaj heslo',
                        prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
                        errorStyle: const TextStyle(color: Colors.yellow),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            )
                        ),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.yellow,
                            )
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.yellow,
                            )
                        ),
                        suffixIcon: IconButton(
                            onPressed: () => showPassword(),
                            icon: Icon(passwordNotShown ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: Colors.white)
                        )
                    ),
                    style: Theme_.lightTextTheme.headline3,
                    obscureText: passwordNotShown,
                  ),
                ),*/
                /*const SizedBox(
                  height: 25,
                ),
                PasswordAgainInputWidget(focusNode: _passwordAgainFocusNode),*/
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    controller: password_again,
                    validator: (value) => validatePasswordCheck(value, password.text, "heslo znova"),
                    decoration: InputDecoration(
                        hintText: 'Zadaj heslo znova',
                        prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
                        errorStyle: const TextStyle(color: Colors.yellow),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            )
                        ),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.yellow,
                            )
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.yellow,
                            )
                        ),
                        suffixIcon: IconButton(
                            onPressed: () => showAgainPassword(),
                            icon: Icon(passwordAgainNotShown ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: Colors.white)
                        )
                    ),
                    style: Theme_.lightTextTheme.headline3,
                    obscureText: passwordAgainNotShown,
                  ),
                ),*/
                const Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: SubmitButtonWidget()
                    )
                )
              ],
            ),
            )
          ),
    );
  }
}

class EmailInputWidget extends StatelessWidget {
  const EmailInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: BlocBuilder<RegisterStartCubit, RegisterStartState>(
          builder: (context, state) {
            EmailInput emailValue = context.read<RegisterStartCubit>().email;

            return TextFormField(
                initialValue: emailValue.value,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Zadaj e-mail',
                  prefixIcon: const Icon(FontAwesomeIcons.envelope, color: Colors.white),
                  errorStyle: const TextStyle(color: Colors.yellow),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.white,
                      )
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.yellow,
                      )
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.yellow,
                      )
                  ),
                  errorText: emailValue.invalid
                      ? 'Zadaný e-mail je v zlom formáte'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {

                  context.read<RegisterStartCubit>().onEmailChanged(value);
                },
                textInputAction: TextInputAction.next,
                style: Theme_.lightTextTheme.headline3,
            );
          },
        )
    );
  }
}

class UsernameInputWidget extends StatelessWidget {
  const UsernameInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: BlocBuilder<RegisterStartCubit, RegisterStartState>(
        builder: (context, state) {
          StringInput usernameValue = context.read<RegisterStartCubit>().username;

          return TextFormField(
            initialValue: usernameValue.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Zadaj prihlasovacie meno',
              prefixIcon: const Icon(FontAwesomeIcons.user, color: Colors.white),
              errorStyle: const TextStyle(color: Colors.yellow),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.white,
                  )
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.yellow,
                  )
              ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.yellow,
                  )
              ),
              errorText: usernameValue.invalid
                  ? 'Prihlasovacie meno nesmie byť prázdne'
                  : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {

              context.read<RegisterStartCubit>().onUsernameChanged(value);
            },
            textInputAction: TextInputAction.next,
            style: Theme_.lightTextTheme.headline3,
          );

        },
      )
    );
  }
}

class PasswordInputsWidget extends StatelessWidget{
  const PasswordInputsWidget({Key? key, required this.focusNodePassword1, required this.focusNodePassword2}) : super(key: key);

  final FocusNode focusNodePassword1;
  final FocusNode focusNodePassword2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterStartCubit, RegisterStartState>(
      builder: (context, state) {
        return Column(
          children: [
            PasswordInputWidget(focusNode: focusNodePassword1),
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

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    StringInput passwordValue = context.read<RegisterStartCubit>().password;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextFormField(
            initialValue: passwordValue.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Zadaj heslo',
              prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
              errorStyle: const TextStyle(color: Colors.yellow),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.white,
                  )
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.yellow,
                  )
              ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.yellow,
                  )
              ),
              errorText: passwordValue.invalid
                  ? 'Heslo nesmie byť prázdne'
                  : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {

              context.read<RegisterStartCubit>().onPasswordChanged(value);
              context.read<RegisterStartCubit>().onPasswordAgainUnfocused();
            },
            textInputAction: TextInputAction.next,
            style: Theme_.lightTextTheme.headline3,
          )
      );
  }
}

class PasswordAgainInputWidget extends StatelessWidget {
  const PasswordAgainInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    PasswordAgainInput passwordAgainValue = context.read<RegisterStartCubit>().passwordAgain;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextFormField(
            initialValue: passwordAgainValue.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Zadaj heslo znova',
              prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
              errorStyle: const TextStyle(color: Colors.yellow),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.white,
                  )
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.yellow,
                  )
              ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.yellow,
                  )
              ),
              errorText: passwordAgainValue.invalid ? returnErrorText(passwordAgainValue) : null,
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {

              context.read<RegisterStartCubit>().onPasswordAgainChanged(value);
            },
            textInputAction: TextInputAction.next,
            style: Theme_.lightTextTheme.headline3,
          )
      );
  }

  String returnErrorText(PasswordAgainInput inputError){
    switch(inputError.error){
      case PasswordAgainInputError.invalid: {
        return "Heslo nesmie byť prázdne";
      }

      case PasswordAgainInputError.mismatch:{
        return "Heslá nie sú rovnaké";
      }

      default :{
        return "";
      }
    }
  }
}

class SubmitButtonWidget extends StatelessWidget{
  const SubmitButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterStartCubit, RegisterStartState>(
        //buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state){
          return ElevatedButton(
            onPressed: context.read<RegisterStartCubit>().status.isValidated
            ? () => BlocProvider.of<RegisterStartCubit>(context).authenticate()
                : null,
            child: const Icon(FontAwesomeIcons.arrowRight),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                primary: Color(0xff000428), // <-- Button color
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