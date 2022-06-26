import 'dart:convert';

import 'package:akcosky/UI/validation_components/event/ActivityTypeWidget.dart';
import 'package:akcosky/UI/validation_components/event/DateInputWidget.dart';
import 'package:akcosky/UI/validation_components/event/NewEventInputWidget.dart';
import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/cubit/events/events_cubit.dart';
import 'package:akcosky/cubit/newevent/newevent_cubit.dart';
import 'package:akcosky/models/UserChip.dart';
import 'package:akcosky/models/validation/DateInput.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

import '../Helpers/DatePickerColor.dart';
import '../cubit/validation/validation_cubit.dart';
import '../models/Group.dart';
import '../models/validation/ActivityTypeInput.dart';
import '../models/validation/StringInput.dart';
import '../theme.dart';

class NewEvent extends StatelessWidget {

  NewEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<ValidationElement, FormzInput> input = {
      ValidationElement.title: StringInput.pure(''),
      ValidationElement.description: StringInput.pure(''),
      ValidationElement.place: StringInput.pure(''),
      ValidationElement.date: DateInput.pure(false),
      ValidationElement.activityType: ActivityTypeInput.pure(false)
    };

    EventRepository eventRepository = RepositoryProvider.of<EventRepository>(context);

    return MultiBlocProvider(
          providers: [
            BlocProvider<NewEventCubit>(
              create: (context) => NewEventCubit(eventRepository),
            ),
            BlocProvider<ValidationCubit>(
              create: (BuildContext context) => ValidationCubit(inputsMap: input),
            )
          ],
          child: NewEventForm(),
    );
  }
}

class NewEventForm extends StatefulWidget {
  const NewEventForm({Key? key}) : super(key: key);

  @override
  State<NewEventForm> createState() => _NewEvent();
}

class _NewEvent extends State<NewEventForm> {
  var eventTitle = TextEditingController();
  var eventDescription = TextEditingController();
  var eventPlace = TextEditingController();
  var eventTransport = TextEditingController();
  var eventAccommodation = TextEditingController();
  var eventEstimatedPrice = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _placeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        context.read<ValidationCubit>().onNewEventInputUnfocused(ValidationElement.title);
        //FocusScope.of(context).requestFocus(_usernameFocusNode);
      }
    });

    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        context.read<ValidationCubit>().onNewEventInputUnfocused(ValidationElement.description);
        //FocusScope.of(context).requestFocus(_usernameFocusNode);
      }
    });

    _placeFocusNode.addListener(() {
      if (!_placeFocusNode.hasFocus) {
        context.read<ValidationCubit>().onNewEventInputUnfocused(ValidationElement.place);

        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _placeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<NewEventCubit, NewEventState>(listener: (context, state) {
        if (state is NewEventFinish) {
          Navigator.pop(context, true);
        } else if (state is NewEventError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      }, builder: (context, state) {
        return initialNewEventPage(context);
      },
    );
  }

  Widget initialNewEventPage(BuildContext context) {
    int currentStep_ = BlocProvider.of<NewEventCubit>(context).stepperState;

    return FutureBuilder(
        future: _initImages(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> actionTypes) {
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
                        if (currentStep_ != 0)
                          Expanded(
                            child: ElevatedButton(
                                onPressed: controls.onStepCancel,
                                child: const Text('SPÄŤ'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(7),
                                  primary: Colors.white, // <-- Button color
                                  onPrimary: Color(0xff36454F), // <-- Splash color
                                )),
                          ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: context.read<ValidationCubit>().status.isValidated
                                    ? controls.onStepContinue : null,
                                child: currentStep_ != 2 ? const Text('ĎALEJ') : const Text("DOKONČI"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(7),
                                  primary: Color(0xff000428), // <-- Button color
                                  onPrimary: Colors.white, // <-- Splash color
                                ))),
                      ],
                    ),
                  );
                },
                onStepContinue: () {
                  if (currentStep_ != 2) {
                    BlocProvider.of<NewEventCubit>(context).updateStepperState(currentStep_ += 1);
                  } else {
                    BlocProvider.of<NewEventCubit>(context).finishCreation(
                        eventTitle.text,
                        eventDescription.text,
                        eventPlace.text,
                        eventTransport.text,
                        eventAccommodation.text,
                        eventEstimatedPrice.text,
                        BlocProvider.of<AuthenticationCubit>(context).userRepository.getUser().id);
                  }
                },
                onStepCancel: () {
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
                        child: AnimatedSwitcher(duration: const Duration(milliseconds: 2000), child: participants(context))),
                  ),
                  Step(
                    isActive: currentStep_ == 2,
                    title: const Text('Dodatočné\ninformácie'),
                    content: Container(alignment: Alignment.centerLeft, child: additionalInformation()),
                  )
                ],
              ));
        });
  }

  Widget basicInformation(
    context,
    List<String> actionTypes,
  ) {

    return Column(children: <Widget>[
      Text(
        'Názov akcie',
        style: Theme_.lightTextTheme.headline2,
      ),
      NewEventInputWidget(focusNode: _titleFocusNode, element_: ValidationElement.title, icon: Icons.title, hintText: "Zadaj názov akcie",
          errorText: "Názov akcie nesmie byť prázdny"),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          'Popis/Plán akcie',
          style: Theme_.lightTextTheme.headline2,
        ),
      ),
      NewEventInputWidget(focusNode: _descriptionFocusNode, element_: ValidationElement.description, icon: FontAwesomeIcons.edit, hintText: "Zadaj popis/plán akcie",
        errorText: "Popis/plán akcie nesmie byť prázdny", keyboard: TextInputType.multiline,),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          'Vyber typ akcie',
          style: Theme_.lightTextTheme.headline2,
        ),
      ),
      ActivityTypeWidget(isError: false, actionTypes: actionTypes),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          'Miesto konania',
          style: Theme_.lightTextTheme.headline2,
        ),
      ),
      NewEventInputWidget(focusNode: _placeFocusNode, element_: ValidationElement.place, icon: FontAwesomeIcons.mapMarkerAlt, hintText: "Zadaj miesto konania akcie",
        errorText: "Miesto akcie nesmie byť prázdne"),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Dátum a čas konania',
          style: Theme_.lightTextTheme.headline2,
        ),
      ),
      DateInputWidget(isError: false),
    ]);
  }

  Widget participants(BuildContext context) {
    Map<String, Group> groups = BlocProvider.of<AuthenticationCubit>(context).userRepository.getUser().groups;
    Group selectedGroup = BlocProvider.of<NewEventCubit>(context).selectedGroup;
    Map<String, UserChip> participants = BlocProvider.of<NewEventCubit>(context).usersFromSelectedGroup;
    bool chooseAll_ = BlocProvider.of<NewEventCubit>(context).chooseAll;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text("Vyber skupinu", style: Theme_.lightTextTheme.headline2)),
        Wrap(direction: Axis.horizontal, children: returnUserChips(context, groups, selectedGroup)),
        if (selectedGroup.id != "") Center(child: Text("Vyber účastníkov", style: Theme_.lightTextTheme.headline2)),
        selectAll(context, chooseAll_, selectedGroup.id),
        Wrap(
            direction: Axis.horizontal,
            children: List<Widget>.generate(participants.length, (index) {
              return userChip(context, participants.values.elementAt(index));
            })),
      ],
    );
  }

  List<Widget> returnUserChips(BuildContext context, Map<String, Group> groups, Group selectedGroup) {
    List<Widget> widgets = List.empty(growable: true);
    groups.forEach((key, value) => widgets.add(groupChip(context, value, selectedGroup)));

    return widgets;
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
                BlocProvider.of<NewEventCubit>(context).updateSelectedUser(userChip.user.id);
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
                BlocProvider.of<NewEventCubit>(context).updateSelectedUser(userChip.user.id);
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
                BlocProvider.of<NewEventCubit>(context).updateSelectedGroup(group);
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
                BlocProvider.of<NewEventCubit>(context).updateSelectedGroup(group);
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
              BlocProvider.of<NewEventCubit>(context).updateAllUsersInSelectedGroup();
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
              BlocProvider.of<NewEventCubit>(context).updateAllUsersInSelectedGroup();
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
          decoration: const InputDecoration(hintText: 'Vlož link na dopravu', prefixIcon: Icon(FontAwesomeIcons.plane, color: Colors.white)),
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
          decoration: const InputDecoration(hintText: 'Vlož link na ubytovanie', prefixIcon: Icon(FontAwesomeIcons.hotel, color: Colors.white)),
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
          decoration: const InputDecoration(hintText: 'Zadaj odhadovanú cenu', prefixIcon: Icon(FontAwesomeIcons.euroSign, color: Colors.white)),
          style: Theme_.lightTextTheme.headline3,
        ),
      ),
    ]);
  }

  Future<List<String>> _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys.where((String key) => key.contains('activityTypes/')).toList();

    return imagePaths;
  }
}
