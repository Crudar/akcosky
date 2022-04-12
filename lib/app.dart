import 'package:akcosky/UI/groups.dart';
import 'package:akcosky/UI/new_event.dart';
import 'package:akcosky/resources/AuthenticationRepository.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:akcosky/resources/UserRepository.dart';
import 'package:akcosky/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'UI/email_verification.dart';
import 'UI/login.dart';
import 'UI/mainUI.dart';
import 'UI/register.dart';
import 'cubit/authentication/authentication_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'cubit/mainUI/main_ui_cubit.dart';

class App extends StatelessWidget{
  const App({Key? key, required this.authenticationRepository,required this.userRepository,
    required this.eventRepository}) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final EventRepository eventRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: eventRepository),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthenticationCubit(authenticationRepository: authenticationRepository,
            userRepository: userRepository)
              )
              ,
              BlocProvider(
                create: (context) => MainUiCubit(),
              )
              ],
          child: AppView(),
      )
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('sk')
      ],
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
          case '/mainUI':
            return MaterialPageRoute(
                builder: (context){
                return MainUI();
              }
            );
          case '/groups':
            return MaterialPageRoute(
                builder: (context){
                  return Groups();
                }
            );
          case '/newevent':
            return MaterialPageRoute(
                builder: (context){

              return NewEvent();
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
              _navigator.pushNamedAndRemoveUntil('/', (route) => false); // TODO - toto nech nenaviguje na login lebo tam uz je, nech skusi ukazat snackbar ???
              }
            else if(state is AuthenticationAuthenticated){
              _navigator.pushNamedAndRemoveUntil('/mainUI', (route) => false);
              }
            },
          child: child
          );
      },
    );
  }
}