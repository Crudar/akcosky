import 'package:akcosky/UI/validation_components/PasswordInputWidget.dart';
import 'package:akcosky/UI/validation_components/PasswordInputWidgetWithCubit.dart';
import 'package:akcosky/UI/validation_components/UsernameInputWidget.dart';
import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/models/validation/NonAuthenticated.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:akcosky/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../cubit/validation/validation_cubit.dart';
import '../models/validation/StringInput.dart';

class Login extends StatelessWidget {

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<ValidationElement, FormzInput> input = {
      ValidationElement.username: StringInput.pure(""),
      ValidationElement.password: StringInput.pure(""),
      ValidationElement.nonauthenticated: NonAuthenticated.pure()
    };

    return BlocProvider<ValidationCubit>(
          create: (BuildContext context) => ValidationCubit(inputsMap: input),
          child: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget{
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm>{
  bool passwordNotShown = true;

  var login = TextEditingController();
  var password = TextEditingController();

  showPassword() {
    setState(() {
      passwordNotShown = !passwordNotShown;
    });
  }

  void navigateToRegister(BuildContext context) async {

    //dynamic result = await Navigator.pushNamed(context, '/registerstart');
    Navigator.pushNamed(context, '/registerstart');

    /*if(result as bool) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Bol si úspešne zaregistrovaný!")));
    }*/
  }

  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      body: Container(
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                'Prihlásenie',
                style: Theme_.lightTextTheme.headline1,
              ),
            ),
            Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      UsernameInputWidget(focusNode: _usernameFocusNode),
                      const SizedBox(
                        height: 25,
                      ),
                      PasswordInputWidgetWithCubit(focusNode: _passwordFocusNode, passwordAgain: false),
                      Center(
                          child: Column(
                              children:[
                          const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: SubmitButtonWidget()
                            ),
                                Padding(padding: const EdgeInsets.only(top: 15),
                                  child: Builder(
                                    builder: (context) => RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Nemáš účet ? ',
                                        style: Theme_.lightTextTheme.headline3
                                      ),
                                      TextSpan(
                                        text: "Vytvor si ho",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          decoration: TextDecoration.underline,
                                          fontSize: Theme_.lightTextTheme.headline3?.fontSize,
                                          fontWeight: Theme_.lightTextTheme.headline3?.fontWeight,
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = (){
                                          /*Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const Register())
                                          );*/
                                          navigateToRegister(context);
                                        }
                                      )
                                    ]
                                    )
                                  ),
                                  )
                                )
                            ]
                          )
                      )
                    ],
                  ),
              ),
          ],
        ),
        )
    );
  }
}

class SubmitButtonWidget extends StatelessWidget{
  const SubmitButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if(state is AuthenticationUnAuthenticated){
              context.read<ValidationCubit>().onNonAuthenticated();
            }
          },
        builder: (context, state) {
          return BlocBuilder<ValidationCubit, ValidationState>(
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: context.read<ValidationCubit>().status.isValidated
                      ? () => BlocProvider.of<AuthenticationCubit>(context).login(context.read<ValidationCubit>().inputsMap[ValidationElement.username]?.value,
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
            });
        },
      );
    }
  }