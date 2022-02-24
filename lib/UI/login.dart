import 'package:flutter/material.dart';
import 'package:akcosky/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatelessWidget{
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xff649173),
              Color(0xffDBD5A4)
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1.0),
                              ),
                              hintStyle: TextStyle(fontSize: 15.0, color: Colors.white), // TODO - brat zo súboru ?
                              hintText: 'Zadaj prihlasovacie meno',
                            ),
                          ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                            hintStyle: TextStyle(fontSize: 15.0, color: Colors.white), // TODO - brat zo súboru ?
                            hintText: 'Zadaj heslo',
                          ),
                        ),
                      ),
                      Center(
                          child: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(FontAwesomeIcons.arrowRight),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            primary: Color(0xff649173), // <-- Button color
                            onPrimary: Colors.white, // <-- Splash color
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