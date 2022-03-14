import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _Groups();
}

class _Groups extends State<Groups>{
  final groups = <String>['Skupina 244', 'Rakeťáci 2', 'Test']; // Creates growable list.
  var group = TextEditingController();

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
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Skupiny',
                  style: Theme_.lightTextTheme.headline1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Tvoje skupiny',
                  style: Theme_.lightTextTheme.headline2,
                ),
              ),
              listOfGroups(groups),
              Text(
                'Pridaj sa do skupiny',
                style: Theme_.lightTextTheme.headline2,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextField(
                  controller: group,
                  decoration: const InputDecoration(
                      hintText: 'Zadaj invitačný kód',
                      prefixIcon: Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white)
                  ),
                  style: Theme_.lightTextTheme.headline3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    onPressed: () {
                      //BlocProvider.of<AuthenticationCubit>(context).login(login.text, password.text);
                    },
                    child: const Icon(FontAwesomeIcons.arrowRight),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Color(0xff000428), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Vytvor novú skupinu',
                  style: Theme_.lightTextTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextField(
                  controller: group,
                  decoration: const InputDecoration(
                      hintText: 'Zadaj názov novej skupiny',
                      prefixIcon: Icon(FontAwesomeIcons.userFriends, color: Colors.white)
                  ),
                  style: Theme_.lightTextTheme.headline3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    onPressed: () {
                      //BlocProvider.of<AuthenticationCubit>(context).login(login.text, password.text);
                    },
                    child: const Icon(FontAwesomeIcons.arrowRight),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Color(0xff000428), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    )
                ),
              ),
            ]
          )
        )
    );
  }

  Widget listOfGroups(List groups){
    return ListView.builder(
      itemBuilder: (BuildContext, index){
        return Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(
                    Radius.circular(5.0))
            ),
          child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(groups[index],
                  style: Theme_.lightTextTheme.headline6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Invitačný kód",
                          style: Theme_.lightTextTheme.headline3)
                  ],
                )
              ]
          )
        );
      },
      itemCount: groups.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
    );
  }

}