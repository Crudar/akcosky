import 'package:akcosky/cubit/groups/groups_cubit.dart';
import 'package:akcosky/resources/GroupsRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../cubit/authentication/authentication_cubit.dart';
import '../models/Group.dart';
import '../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _Groups();
}

class _Groups extends State<Groups>{
  //final groups = <String>['Skupina 244', 'Rakeťáci 2', 'Test']; // Creates growable list.
  var addToGroup = TextEditingController();
  var newGroup = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _userRepository = BlocProvider.of<AuthenticationCubit>(context).userRepository;

    return BlocProvider(
      create: (context) => GroupsCubit(GroupsRepository(), _userRepository),
      child: Scaffold(
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
          child: BlocConsumer<GroupsCubit, GroupsState>(
            listener: (context, state){
              if (state is GroupsStatusMessage){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  )
                );
              }
            },
            builder: (context, state){
              return initialGroupsPage(_userRepository.getUser().groups);
            }
          ),
        )
      )
    );
  }

  Widget initialGroupsPage(List<Group> groups){
    return Column(
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
              if(groups.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Nie si v žiadnej skupine. Pridaj sa do nejakej!",
                    style: Theme_.lightTextTheme.headline3)
                )
              else
                listOfGroups(groups),
              Text(
                'Pridaj sa do skupiny',
                style: Theme_.lightTextTheme.headline2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextField(
                  controller: addToGroup,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Zadaj invitačný kód',
                      prefixIcon: Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white)
                  ),
                  style: Theme_.lightTextTheme.headline3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Builder(builder: (context) => ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GroupsCubit>(context).addUserToGroup(addToGroup.text);
                    },
                    child: const Icon(FontAwesomeIcons.arrowRight),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Color(0xff000428), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    )
                ),
                )
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
                  controller: newGroup,
                  decoration: const InputDecoration(
                      hintText: 'Zadaj názov novej skupiny',
                      prefixIcon: Icon(FontAwesomeIcons.userFriends, color: Colors.white)
                  ),
                  style: Theme_.lightTextTheme.headline3,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Builder(builder: (context) => ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GroupsCubit>(context).createNewGroup(newGroup.text);
                      },
                      child: const Icon(FontAwesomeIcons.arrowRight),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        primary: Color(0xff000428), // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
                      )
                  ),
                )
              ),
            ]
          );
  }

  Widget listOfGroups(List groups){
    return ListView.builder(
      itemBuilder: (BuildContext, index){
        final Group currentItem = groups[index];

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
                Text(currentItem.title,
                  style: Theme_.lightTextTheme.headline6),
                    Builder(builder: (context) => GestureDetector(
                    onTap: (){
                      BlocProvider.of<GroupsCubit>(context).copyInviteCodeToClipboard(currentItem.inviteCode);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white),
                        SizedBox(width: 10),
                        Text(currentItem.inviteCode,
                            style: Theme_.lightTextTheme.headline3)
                    ],
                    )
                  )
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