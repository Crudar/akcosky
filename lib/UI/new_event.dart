import 'dart:convert';

import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/cubit/newevent/newevent_cubit.dart';
import 'package:akcosky/models/UserChip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/Group.dart';
import '../theme.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEvent();
}

class _NewEvent extends State<NewEvent>{
  var eventTitle = TextEditingController();
  var eventDescription = TextEditingController();
  var eventPlace = TextEditingController();
  //var eventType =

  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) => NewEventCubit(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              key: UniqueKey(),
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
              child: BlocConsumer<NewEventCubit, NewEventState>(
                  listener: (context, state){

                  },
                  builder: (context, state) {
                     return initialNewEventPage(context);
                  }
              ),
            )
        )
    );
  }

  Widget initialNewEventPage(BuildContext context){
    int currentStep_ = BlocProvider.of<NewEventCubit>(context).stepperState;

    return FutureBuilder(
        future: _initImages(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> actionTypes){
      return SafeArea(
      left: false,
      right: false,
        child: Stepper(
          currentStep: currentStep_,
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: const Text('ĎALEJ'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(7),
                        primary: Color(0xff000428), // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
                      )
                    )
                  ),
                  const SizedBox(width: 15),
                  if (currentStep_ != 0)
                  Expanded(child:
                    ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: const Text('SPÄŤ'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Colors.white, // <-- Button color
                          onPrimary: Color(0xff36454F), // <-- Splash color
                        )
                    ),
                  )
                ],
              ),
            );
          },
          onStepContinue: (){
            BlocProvider.of<NewEventCubit>(context).updateStepperState(currentStep_ += 1);
          },
          onStepCancel: (){
            BlocProvider.of<NewEventCubit>(context).updateStepperState(currentStep_ -= 1);
          },

          type: StepperType.horizontal,
          steps: <Step>[
            Step(
              isActive: currentStep_ == 0,
              state: currentStep_ > 0 ? StepState.complete : StepState.indexed,
              title: const Text('Základné \ninformácie'),
              content: Container(
                alignment: Alignment.centerLeft,
                child: basicInformation(context, actionTypes.data ?? List.empty()),
              ),
            ),
            Step(
              isActive: currentStep_ == 1,
              state: currentStep_ > 1 ? StepState.complete : StepState.indexed,
              title: const Text('Účastníci'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 2000),
                      child: participants(context)
                  )
              ),
            ),
            Step(
              isActive: currentStep_ == 2,
              title: const Text('Dodatočné\ninformácie'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 1')
              ),
            )
        ],
      )
      );
    }
    );
  }

  Widget basicInformation(context, List<String> actionTypes){
    return Column(
        children: <Widget>[
          Text(
            'Názov akcie',
            style: Theme_.lightTextTheme.headline2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: eventTitle,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Zadaj názov akcie',
                  prefixIcon: Icon(Icons.title, color: Colors.white)
              ),
              style: Theme_.lightTextTheme.headline3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Popis/Plán akcie',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: eventDescription,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: 'Zadaj popis/plán akcie',
                  prefixIcon: Icon(FontAwesomeIcons.edit, color: Colors.white)
              ),
              style: Theme_.lightTextTheme.headline3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Typ akcie',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          Container(margin: const EdgeInsets.only(top: 10),
            height: 60,
            child: listOfActivityTypes(context, actionTypes)
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Miesto konania',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: eventPlace,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: 'Zadaj miesto konania akcie',
                  prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt, color: Colors.white)
              ), //TODO - miesto na výber z google máp
              style: Theme_.lightTextTheme.headline3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Dátum konania',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            /*child: ElevatedButton(
                  onPressed: () {
                    /*showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                      helpText: 'Vyber dátum');*/
                    _selectDate(context);
                    // TODO - spravit nech tam su 2 buttony - 1 dnova akcia a viacdnova akcia
                  },
                  child: const Icon(FontAwesomeIcons.arrowRight),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: Color(0xff000428), // <-- Button color
                    onPrimary: Colors.white, // <-- Splash color
                  )
              ),*/
              child: GestureDetector(onTap: (){
                showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    helpText: 'Vyber dátum');
              },
                child: TextField(
                //controller: eventPlace,
                decoration: const InputDecoration(
                    hintText: 'Vyber dátum konania akcie',
                    prefixIcon: Icon(FontAwesomeIcons.calendar, color: Colors.white)
                ),
              style: Theme_.lightTextTheme.headline3,
              ),//TODO - DatePicker
              )
            )
      ]
    );
  }

  Widget listOfActivityTypes(context, List<String> types){
    String currentSelectedActivityTypeIcon = BlocProvider.of<NewEventCubit>(context).selectedActivityTypeIcon;

    return ListView.separated(
      itemBuilder: (BuildContext, index){
        final String currentItem = types[index];

        if(currentItem != currentSelectedActivityTypeIcon) {
          return ElevatedButton(
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context).updateSelectedActivityType(index, currentItem);
            },
            child: Image.asset(currentItem),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(7),
              primary: Colors.white, // <-- Button color
              onPrimary: Colors.white, // <-- Splash color
            )
        );
        }
        else{
          return ElevatedButton(
              onPressed: () {

              },
              child: Image.asset(currentItem, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(7),
                primary: const Color(0xff000428), // <-- Button color
                onPrimary: Colors.white, // <-- Splash color
              )
          );
        }
      },
      itemCount: types.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(
          width: 15,
        )
    );
  }

  Widget participants(BuildContext context){
    List<Group> groups = BlocProvider.of<AuthenticationCubit>(context).userRepository.getUser().groups;
    Group selectedGroup = BlocProvider.of<NewEventCubit>(context).selectedGroup;
    List<UserChip> usersFromSelectedGroup = BlocProvider.of<NewEventCubit>(context).usersFromSelectedGroup;
    bool chooseAll_ = BlocProvider.of<NewEventCubit>(context).chooseAll;

    return Column(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Vyber skupinu", style: Theme_.lightTextTheme.headline3)
        ,
        Wrap(direction: Axis.horizontal,
            children: [for (var i in groups)
              groupChip(context, i, selectedGroup),
            ]
          )
        ,
        if(selectedGroup.id != "")
          Text("Vyber účastníkov", style: Theme_.lightTextTheme.headline3)
        ,
        selectAll(context, chooseAll_, selectedGroup.id)
        ,
        Wrap(direction: Axis.horizontal,
            children: [for (var i in usersFromSelectedGroup)
              userChip(context, i),
            ]
        ),
      ],
    );
  }

  Widget userChip(BuildContext context, UserChip userChip){
    if(userChip.selected){
      return Padding(
          child: ActionChip(
              label: Text(
                userChip.user.login,
                style: const TextStyle(color: Colors.white)
                ,
              ),
              backgroundColor: const Color(0xff000428),
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context).updateSelectedUser(userChip.user);
              }
          )
          ,
          padding: const EdgeInsets.only(left: 3, right: 3)
      );
    }
    else{
      return Padding(
          child: ActionChip(
              label: Text(
                userChip.user.login,
                style: const TextStyle(color: Colors.black)
                ,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context).updateSelectedUser(userChip.user);
              }
          )
          ,
          padding: const EdgeInsets.only(left: 3, right: 3)
      );
    }
  }

  Widget groupChip(BuildContext context, Group group, Group selectedGroup){
    if(group.id == selectedGroup.id){
      return Padding(child: ActionChip(
          label: Text(
            group.title,
            style: const TextStyle(color: Colors.white)
            ,
          ),
          backgroundColor: const Color(0xff000428),
          onPressed: () {
            BlocProvider.of<NewEventCubit>(context).updateSelectedGroup(group, group.users);
          })
        ,
        padding: const EdgeInsets.only(left: 3, right: 3)
      );
    }
    else{
      return Padding(child: ActionChip(
          label: Text(
            group.title,
            style: TextStyle(color: Colors.black)
            ,
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            BlocProvider.of<NewEventCubit>(context).updateSelectedGroup(group, group.users);
          })
          ,
          padding: const EdgeInsets.only(left: 3, right: 3)
      );
    }
  }

  Widget selectAll(BuildContext context, chooseAll_, String selectedGroup){
    if(selectedGroup != ""){
      if(chooseAll_) {
        return ActionChip(
          avatar: const Icon(Icons.check, color: Colors.white,),
          label: const Text(
            "Vyber všetkých",
            style: TextStyle(color: Colors.white)
            ,
          ),
          backgroundColor: const Color(0xff000428),
          onPressed: () {
            BlocProvider.of<NewEventCubit>(context).updateAllUsersInSelectedGroup();
          }
        );
      }
      else{
        return ActionChip(
            avatar: const Icon(Icons.check, color: Colors.black,),
            label: const Text(
              "Vyber všetkých",
              style: TextStyle(color: Colors.black)
              ,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context).updateAllUsersInSelectedGroup();
            }
        );
      }
    }
    else{
      return const SizedBox.shrink();
    }
  }

  Future<List<String>> _initImages()async{

    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('activityTypes/'))
        .toList();

    return imagePaths;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),

    );
    if (selected != null && selected != DateTime.now()){

    }
  }

}
