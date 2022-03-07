import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:akcosky/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: TextField(
                            controller: login,
                            decoration: const InputDecoration(
                              hintText: 'Zadaj prihlasovacie meno',
                              prefixIcon: Icon(FontAwesomeIcons.user, color: Colors.white)
                            ),
                          style: Theme_.lightTextTheme.headline3,
                          ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            hintText: 'Zadaj heslo',
                            prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
                              suffixIcon: IconButton(
                                  onPressed: () => showPassword(),
                                  icon: Icon(passwordNotShown ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: Colors.white)
                              )
                          ),
                          style: Theme_.lightTextTheme.headline3,
                          obscureText: passwordNotShown
                        ),
                      ),
                      Center(
                          child: Column(
                              children:[
                          Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Icon(FontAwesomeIcons.arrowRight),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary: Color(0xff000428), // <-- Button color
                                  onPrimary: Colors.white, // <-- Splash color
                                )
                              ),
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
                                          color: const Color(0xff000428),
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