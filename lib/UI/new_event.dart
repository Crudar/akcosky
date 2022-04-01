import 'dart:convert';

import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/cubit/events/events_cubit.dart';
import 'package:akcosky/cubit/newevent/newevent_cubit.dart';
import 'package:akcosky/models/UserChip.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/Group.dart';
import '../theme.dart';

class NewEvent extends StatefulWidget {
  final EventRepository eventRepository;
  const NewEvent({Key? key, required this.eventRepository}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEvent();
}

class _NewEvent extends State<NewEvent> {
  var eventTitle = TextEditingController();
  var eventDescription = TextEditingController();
  var eventPlace = TextEditingController();
  var eventTransport = TextEditingController();
  var eventAccommodation = TextEditingController();
  var eventEstimatedPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    EventRepository eventRepository = widget.eventRepository;

    return BlocProvider(
        create: (context) => NewEventCubit(eventRepository),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              key: UniqueKey(),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xff240b36), Color(0xffc31432)])),
              child: BlocConsumer<NewEventCubit, NewEventState>(
                  listener: (context, state) {
                    if (state is NewEventFinish) {
                      Navigator.pop(context, true);
                    }
                    else if (state is NewEventError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return initialNewEventPage(context);
                  }),
            )));
  }

  Widget initialNewEventPage(BuildContext context) {
    int currentStep_ = BlocProvider
        .of<NewEventCubit>(context)
        .stepperState;

    return FutureBuilder(
        future: _initImages(),
        builder:
            (BuildContext context, AsyncSnapshot<List<String>> actionTypes) {
          return SafeArea(
              left: false,
              right: false,
              child: Stepper(
                currentStep: currentStep_,
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        if (currentStep_ != 0)
                          Expanded(
                            child: ElevatedButton(
                                onPressed: controls.onStepCancel,
                                child: const Text('SPÄŤ'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(7),
                                  primary: Colors.white, // <-- Button color
                                  onPrimary:
                                  Color(0xff36454F), // <-- Splash color
                                )),
                          ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: controls.onStepContinue,
                                child: currentStep_ != 2
                                    ? const Text('ĎALEJ')
                                    : const Text("DOKONČI"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(7),
                                  primary:
                                  Color(0xff000428), // <-- Button color
                                  onPrimary: Colors.white, // <-- Splash color
                                ))),
                      ],
                    ),
                  );
                },
                onStepContinue: () {
                  if(currentStep_ != 2){
                    BlocProvider.of<NewEventCubit>(context)
                        .updateStepperState(currentStep_ += 1);
                  }
                  else{
                    BlocProvider.of<NewEventCubit>(context)
                        .finishCreation(eventTitle.text, eventDescription.text, eventPlace.text, eventTransport.text,
                        eventAccommodation.text, eventEstimatedPrice.text, BlocProvider.of<AuthenticationCubit>(context)
                            .userRepository.getUser().id);
                  }
                },
                onStepCancel: () {
                  BlocProvider.of<NewEventCubit>(context)
                      .updateStepperState(currentStep_ -= 1);
                },
                type: StepperType.horizontal,
                steps: <Step>[
                  Step(
                    isActive: currentStep_ == 0,
                    state: currentStep_ > 0
                        ? StepState.complete
                        : StepState.indexed,
                    title: const Text('Základné \ninformácie'),
                    content: Container(
                      alignment: Alignment.centerLeft,
                      child: basicInformation(
                          context, actionTypes.data ?? List.empty()),
                    ),
                  ),
                  Step(
                    isActive: currentStep_ == 1,
                    state: currentStep_ > 1
                        ? StepState.complete
                        : StepState.indexed,
                    title: const Text('Účastníci'),
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 2000),
                            child: participants(context))),
                  ),
                  Step(
                    isActive: currentStep_ == 2,
                    title: const Text('Dodatočné\ninformácie'),
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: additionalInformation()),
                  )
                ],
              ));
        });
  }

  Widget basicInformation(context,
      List<String> actionTypes,) {
    bool isChecked = BlocProvider
        .of<NewEventCubit>(context)
        .moreDayAction;
    String dateAndTime = BlocProvider
        .of<NewEventCubit>(context)
        .dateText;

    return Column(children: <Widget>[
      Text(
        'Názov akcie',
        style: Theme_.lightTextTheme.headline2,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextField(
          controller: eventTitle,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              hintText: 'Zadaj názov akcie',
              prefixIcon: Icon(Icons.title, color: Colors.white)),
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
              prefixIcon: Icon(FontAwesomeIcons.edit, color: Colors.white)),
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
      Container(
          margin: const EdgeInsets.only(top: 10),
          height: 60,
          child: listOfActivityTypes(context, actionTypes)),
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
          keyboardType: TextInputType.text,
          maxLines: null,
          decoration: const InputDecoration(
              hintText: 'Zadaj miesto konania akcie',
              prefixIcon:
              Icon(FontAwesomeIcons.mapMarkerAlt, color: Colors.white)),
          //TODO - miesto na výber z google máp
          style: Theme_.lightTextTheme.headline3,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Dátum a čas konania',
          style: Theme_.lightTextTheme.headline2,
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Checkbox(
                  value: isChecked,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  onChanged: (bool? newValue) {
                    BlocProvider.of<NewEventCubit>(context)
                        .updateMoreDayCheckbox();
                  }),
              Text("Viacdňová akcia", style: Theme_.lightTextTheme.headline3)
            ],
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: GestureDetector(
            onTap: () async {
              if (!isChecked) {
                await showDatePicker(
                    context: context,
                    locale: const Locale("sk", "SK"),
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    helpText: 'Vyber dátum a čas')
                    .then((value) =>
                    BlocProvider.of<NewEventCubit>(context)
                        .updateDate(value));

                await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial)
                    .then((value) =>
                    BlocProvider.of<NewEventCubit>(context)
                        .updateTime(value));
              } else {
                await showDateRangePicker(
                    context: context,
                    locale: const Locale("sk", "SK"),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    helpText: 'Vyber dátum a čas')
                    .then((value) =>
                    BlocProvider.of<NewEventCubit>(context)
                        .updateDateRange(value));
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(FontAwesomeIcons.calendar, color: Colors.white),
                  ),
                  Text(
                    dateAndTime,
                    style: Theme_.lightTextTheme.headline3,
                  ),
                ]))), //TODO - DatePicker
      )
    ]);
  }

  Widget listOfActivityTypes(context, List<String> types) {
    String currentSelectedActivityTypeIcon =
        BlocProvider
            .of<NewEventCubit>(context)
            .selectedActivityTypeIcon;

    return ListView.separated(
        itemBuilder: (BuildContext context, index) {
          final String currentItem = types[index];

          if (currentItem != currentSelectedActivityTypeIcon) {
            return ElevatedButton(
                onPressed: () {
                  BlocProvider.of<NewEventCubit>(context)
                      .updateSelectedActivityType(index, currentItem);
                },
                child: Image.asset(currentItem),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(7),
                  primary: Colors.white, // <-- Button color
                  onPrimary: Colors.white, // <-- Splash color
                ));
          } else {
            return ElevatedButton(
                onPressed: () {},
                child: Image.asset(currentItem, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(7),
                  primary: const Color(0xff000428), // <-- Button color
                  onPrimary: Colors.white, // <-- Splash color
                ));
          }
        },
        itemCount: types.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) =>
        const SizedBox(
          width: 15,
        ));
  }

  Widget participants(BuildContext context) {
    List<Group> groups = BlocProvider
        .of<AuthenticationCubit>(context)
        .userRepository
        .getUser()
        .groups;
    Group selectedGroup = BlocProvider
        .of<NewEventCubit>(context)
        .selectedGroup;
    List<UserChip> usersFromSelectedGroup =
        BlocProvider
            .of<NewEventCubit>(context)
            .usersFromSelectedGroup;
    bool chooseAll_ = BlocProvider
        .of<NewEventCubit>(context)
        .chooseAll;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text(
            "Vyber skupinu", style: Theme_.lightTextTheme.headline2)),
        Wrap(direction: Axis.horizontal, children: [
          for (var i in groups) groupChip(context, i, selectedGroup),
        ]),
        if (selectedGroup.id != "")
          Center(child: Text(
              "Vyber účastníkov", style: Theme_.lightTextTheme.headline2)),
        selectAll(context, chooseAll_, selectedGroup.id),
        Wrap(direction: Axis.horizontal, children: [
          for (var i in usersFromSelectedGroup) userChip(context, i),
        ]),
      ],
    );
  }

  Widget userChip(BuildContext context, UserChip userChip) {
    if (userChip.selected) {
      return Padding(
          child: ActionChip(
              label: Text(
                userChip.user.login,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xff000428),
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context)
                    .updateSelectedUser(userChip.user);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    } else {
      return Padding(
          child: ActionChip(
              label: Text(
                userChip.user.login,
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context)
                    .updateSelectedUser(userChip.user);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    }
  }

  Widget groupChip(BuildContext context, Group group, Group selectedGroup) {
    if (group.id == selectedGroup.id) {
      return Padding(
          child: ActionChip(
              label: Text(
                group.title,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xff000428),
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context)
                    .updateSelectedGroup(group, group.users);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    } else {
      return Padding(
          child: ActionChip(
              label: Text(
                group.title,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context)
                    .updateSelectedGroup(group, group.users);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    }
  }

  Widget selectAll(BuildContext context, chooseAll_, String selectedGroup) {
    if (selectedGroup != "") {
      if (chooseAll_) {
        return ActionChip(
            avatar: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            label: const Text(
              "Vyber všetkých",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xff000428),
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context)
                  .updateAllUsersInSelectedGroup();
            });
      } else {
        return ActionChip(
            avatar: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            label: const Text(
              "Vyber všetkých",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context)
                  .updateAllUsersInSelectedGroup();
            });
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget additionalInformation() {
    return Column(children: <Widget>[
      Text(
      'Doprava',
      style: Theme_.lightTextTheme.headline2,
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
      controller: eventTransport,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
      hintText: 'Vlož link na dopravu',
      prefixIcon: Icon(FontAwesomeIcons.plane, color: Colors.white)),
      style: Theme_.lightTextTheme.headline3,
      ),
    ),
    Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
      'Ubytovanie',
        style: Theme_.lightTextTheme.headline2,
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
      controller: eventAccommodation,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
      hintText: 'Vlož link na ubytovanie',
      prefixIcon: Icon(FontAwesomeIcons.hotel, color: Colors.white)),
      style: Theme_.lightTextTheme.headline3,
      ),
    ),
    Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        'Odhadovaná cena',
        style: Theme_.lightTextTheme.headline2,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextField(
        controller: eventEstimatedPrice,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
        hintText: 'Zadaj odhadovanú cenu',
        prefixIcon: Icon(FontAwesomeIcons.euroSign, color: Colors.white)),
        style: Theme_.lightTextTheme.headline3,
      ),
    ),
    ]
  );
  }

  Future<List<String>> _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('activityTypes/'))
        .toList();

    return imagePaths;
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return const Color(0xffc31432);
    }
    return const Color(0xff000428);
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != DateTime.now()) {}
  }
}
