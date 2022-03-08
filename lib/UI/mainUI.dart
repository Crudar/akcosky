import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme.dart';

class MainUI extends StatelessWidget {
  const MainUI({Key? key}) : super(key: key);

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
                          visible: true,
                          child: IconButton(
                              onPressed: () {  },
                              icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.white, size: 30)
                          )
                      ),
                      Visibility(
                          visible: false,
                          child: IconButton(
                              onPressed: () {  },
                              icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 30)
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
                children: <Widget>[
                  Visibility(
                    visible: true,
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
                              onPressed: () {  },
                              icon: const Icon(FontAwesomeIcons.userFriends, color: Colors.white, size: 50,)
                          )
                        ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[//TODO - FIX OVERFLOW + LEFT COLUMN SHOULD STAY ON THE TOP
                          Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: const SizedBox(
                                width: 300,
                                height: 100,
                                child: Text('A card that can be tapped'),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: const SizedBox(
                                width: 300,
                                height: 100,
                                child: Text('A card that can be tapped'),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: const SizedBox(
                                width: 300,
                                height: 100,
                                child: Text('A card that can be tapped'),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: const SizedBox(
                                width: 300,
                                height: 100,
                                child: Text('A card that can be tapped'),
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
