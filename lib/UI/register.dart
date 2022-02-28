import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  bool passwordNotShown = true;
  bool passwordAgainNotShown = true;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_.light(),
      home: Scaffold(
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
                    'Registrácia',
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
                          decoration: const InputDecoration(
                              hintText: 'Zadaj e-mail',
                              prefixIcon: Icon(FontAwesomeIcons.envelope, color: Colors.white)
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
                            decoration: InputDecoration(
                                hintText: 'Zadaj heslo',
                                prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
                              suffixIcon: IconButton(
                                  onPressed: () => showPassword(),
                                  icon: Icon(passwordNotShown ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: Colors.white)
                              )
                            ),
                            style: Theme_.lightTextTheme.headline3,
                            obscureText: passwordNotShown,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Zadaj heslo znova',
                                prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
                                suffixIcon: IconButton(
                                    onPressed: () => showAgainPassword(),
                                    icon: Icon(passwordAgainNotShown ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: Colors.white)
                                )
                            ),
                            style: Theme_.lightTextTheme.headline3,
                            obscureText: passwordAgainNotShown,
                        ),
                      ),
                      Center(
                          child: Padding(
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
                              )
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}