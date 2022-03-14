import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme.dart';

class MainUI extends StatefulWidget {
  const MainUI({Key? key}) : super(key: key);

  @override
  State<MainUI> createState() => _MainUI();
}

class _MainUI extends State<MainUI>{
  bool menuVisible = false;

  showMenu(){
    setState(() {
      menuVisible = !menuVisible;
    });
  }

  @override
  Widget build(context) {
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
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children:[
                      Visibility(
                          visible: !menuVisible,
                          child: Center(
                              child: IconButton(
                                onPressed: () {
                                  showMenu();
                                },
                                icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.white, size: 30)
                            )
                          )
                      ),
                      Visibility(
                          visible: menuVisible,
                          child: Center(
                              child: IconButton(
                              onPressed: () {
                                showMenu();
                              },
                              icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 30)
                            )
                          )
                      ),
                      SizedBox(width: 15),
                      Text(
                          "Akcošky",
                          style: Theme_.lightTextTheme.headline2)
                    ],
                  )
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                     Visibility(
                      visible: menuVisible,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                             IconButton(
                                icon: const Icon(FontAwesomeIcons.solidCalendarPlus, color: Colors.white, size: 50),
                              onPressed: () {  },
                              )
                              ,
                              const SizedBox(height: 15)
                              ,
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/groups');
                                  },
                                  icon: const Icon(FontAwesomeIcons.userFriends, color: Colors.white, size: 50,)
                              )
                            ],
                        ),
                      ),
                  ),
                const SizedBox(width: 20),
                     Expanded(child:
                       Padding(
                        padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[//TODO - FIX OVERFLOW + LEFT COLUMN SHOULD STAY ON THE TOP
                            Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  debugPrint('Card tapped.');
                                },
                                child: SizedBox(
                                  height: 100,
                                  child: Text('A card that can be tapped')
                                ),
                              ),
                            ),
                            Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  debugPrint('Card tapped.');
                                },
                                child: SizedBox(
                                    height: 100,
                                    child: Text('A card that can be tapped')
                                ),
                              ),
                            ),
                            Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  debugPrint('Card tapped.');
                                },
                                child: SizedBox(
                                    height: 100,
                                    child: Text('A card that can be tapped')
                                ),
                              ),
                            ),
                            Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  debugPrint('Card tapped.');
                                },
                                child: SizedBox(
                                    height: 100,
                                    child: Text('A card that can be tapped')
                                ),
                                ),
                              ),
                            ]
                          )
                      )
                   )
                ],
              )
            ],
          ),
        )
      )
    );
  }
}
