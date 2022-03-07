import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:akcosky/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'UI/email_verification.dart';
import 'UI/login.dart';
import 'UI/register.dart';
import 'cubit/authentication/authentication_cubit.dart';

class App extends StatelessWidget{
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthenticationCubit(),
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget{
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_.light(),
      navigatorKey: _navigatorKey,
      onGenerateRoute: (settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
                builder: (context) {
                  return Login();
                }
            );
          case '/registerfinal':
              return MaterialPageRoute(
                  builder: (context) {
                    return EmailVerification(registerRepository: arguments as RegisterRepository);
                  }
            );
          case '/registerstart':
            return MaterialPageRoute(
                builder: (context) {
                  return Register();
                }
            );
          default:
            return null;
        }
      },
      builder: (context, child){
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state){
            if (state is AuthenticationUnAuthenticated) {
              _navigator.pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          child: child
          );
      },
    );
  }
}