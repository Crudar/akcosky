import 'package:akcosky/cubit/eventdetail/changes/changes_cubit.dart';
import 'package:akcosky/cubit/eventdetail/date/date_cubit.dart';
import 'package:akcosky/cubit/eventdetail/info/info_cubit.dart';
import 'package:akcosky/cubit/eventdetail/participants/participants_cubit.dart';
import 'package:akcosky/cubit/eventdetail/voting/voting_cubit.dart';
import 'package:akcosky/models/Event_.dart';
import 'package:akcosky/models/TypeEnum.dart';
import 'package:akcosky/models/VoteEnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Helpers/DatePickerColor.dart';
import '../cubit/authentication/authentication_cubit.dart';
import '../models/DateEnum.dart';
import '../models/Info.dart';
import '../models/User.dart';
import '../models/Vote.dart';
import '../models/VoteEnum.dart';
import '../resources/EventRepository.dart';
import '../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key, required this.event}) : super(key: key);
  final Event_ event;

  @override
  State<EventDetail> createState() => EventDetailState();
}

class EventDetailState extends State<EventDetail> {

  Map<TypeEnum, TextEditingController> controllers = {};

  @override
  Widget build(BuildContext context) {
    Event_ selectedEvent = widget.event;

    User user = BlocProvider.of<AuthenticationCubit>(context)
        .userRepository
        .getUser();

    Vote actualUserVote = Vote("", "", "", "", VoteEnum.undefined);

    for (var element in selectedEvent.votes) {
      if(element.userID == user.id){
        actualUserVote = element;
        break;
      }
    }

    EventRepository eventRepository =
        RepositoryProvider.of<EventRepository>(context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ParticipantsCubit>(
              create: (context) => ParticipantsCubit(),
            ),
            BlocProvider<VotingCubit>(
              create: (context) => VotingCubit(eventRepository),
            ),
            BlocProvider<ChangesCubit>(
              create: (context) => ChangesCubit(eventRepository),
            )
          ],
          child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: SafeArea(
                  child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.maxFinite,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/activityHeaders/" +
                                selectedEvent.type +
                                ".jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  Positioned(
                    left: 15,
                    top: 15,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(FontAwesomeIcons.arrowLeft,
                            color: Colors.white, size: 30)),
                  ),
                  Positioned.fill(
                      top: 230,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Color(0xff4f0c2f),
                                    Color(0xffc31432)
                                  ])),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15, bottom: 85),
                            child: BlocConsumer<ChangesCubit, ChangesState>(
                              builder: (context, state) {
                                if(state is ChangesInitial){
                                  return SingleChildScrollView(
                                      child: //eventInfo(context, selectedEvent, controllers),
                                      Column(children:[
                                        eventInfo(context, selectedEvent, controllers),
                                        saveButtonChanges(context, selectedEvent, controllers)
                                      ]
                                  ),
                                  );
                                }
                                else if (state is ChangesSave){
                                  return SingleChildScrollView(
                                    child: Column(children:[
                                        eventInfo(context, selectedEvent, controllers),
                                        //saveButtonChanges(context, selectedEvent, controllers)
                                    ]
                                    ),
                                  );
                                }
                                else if(state is ChangesSuccessfull){
                                  return SingleChildScrollView(
                                      child: eventInfo(context, selectedEvent, controllers));
                                }
                                else{
                                  return SizedBox.shrink();
                                }
                              },
                              listener: (context, state){
                                if(state is ChangesSuccessfull){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text("Akcia bola ??spe??ne aktualizovan??!")));
                                }
                                else if(state is ChangesStatusMessage){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(state.message)));
                                }
                              }
                              ),
                            )
                          )),
                  Positioned(
                      bottom: 0, child: /*voted(context)*/ /*alreadyVoted(context)*/
                  BlocConsumer<VotingCubit, VotingState>(
                    builder: (context, state) {
                      if (state is VotingInitial){
                        if(actualUserVote.vote == VoteEnum.undefined) {
                          return Unvoted(context, actualUserVote);
                        } else {
                          return alreadyVoted(context, actualUserVote);
                        }
                      } else if (state is VotingSuccessfullVote) {
                        return alreadyVoted(context, actualUserVote);
                      } else if (state is VotingUnvoted) {
                        return Unvoted(context, actualUserVote);
                      }
                        else {
                          if(actualUserVote.vote == VoteEnum.undefined) {
                            return Unvoted(context, actualUserVote);
                          } else {
                            return alreadyVoted(context, actualUserVote);
                          }
                      }
                    },
                    listener: (context, state){
                      if(state is VotingError){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                        ),
                        );
                      }
                      else if(state is VotingSuccessfullVote){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Zmena hlasu bola ulo??en?? do datab??zy !"),
                        ),
                        );

                        actualUserVote.vote = state.newVote.vote;

                        BlocProvider.of<ParticipantsCubit>(context)
                            .refresh();
                      }
                    }
                  ),)
                ],
              ))),
        ));
  }
}

Widget eventInfo(BuildContext context, Event_ _selectedEvent, Map<TypeEnum, TextEditingController> controllers) {
  Event_ selectedEvent = _selectedEvent;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedEvent.name, style: Theme_.lightTextTheme.headline2),
            Text("Vytvoril: " + selectedEvent.createdBy,
                style: Theme_.lightTextTheme.headline3),
          ],
        )),
        Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                  "assets/icons/activityTypes/" + selectedEvent.type + ".png",
                  width: 55,
                  height: 55),
            )),
      ]),
      Text(selectedEvent.description, style: Theme_.lightTextTheme.headline3),
      const SizedBox(height: 15),
      BlocBuilder<ParticipantsCubit, ParticipantsState>(
        builder: (context, state) {
          if (state is ParticipantsInitial) {
            return participantsInitial(context, selectedEvent);
          } else if (state is ParticipantsShowMore) {
            return participantsRolled(context, selectedEvent);
          }
          return const SizedBox();
        },
      ),
      const SizedBox(height: 15),

      Column(
       children: infoRows(context, controllers, _selectedEvent.info),
      )
    ],
  );
}

Widget saveButtonChanges(BuildContext context, Event_ selectedEvent, Map<TypeEnum, TextEditingController> controllers){
  User user = BlocProvider.of<AuthenticationCubit>(context)
      .userRepository
      .getUser();

  return Center(child: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ElevatedButton(
            onPressed: (() => BlocProvider.of<ChangesCubit>(context).saveChanges(selectedEvent, controllers)),
            child: Text(user.id == selectedEvent.createdBy ? "ULO?? ZMENY" : "NAVRHNI ZMENY"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(7),
              primary: Color(0xff000428), // <-- Button color
              onPrimary: Colors.white, // <-- Splash color
            )))
  );
}

List<Widget> infoRows(BuildContext context, Map<TypeEnum, TextEditingController> controllers, Map<TypeEnum, Info> info){

  List<Widget> rows = List.empty(growable: true);

  for(Info oneInfo in info.values){
    rows.add(oneInfoRow(context, oneInfo, controllers));
  }

  return rows;

}

Widget oneInfoRow(BuildContext context, Info info, Map<TypeEnum, TextEditingController> controllers) {

  TextEditingController? controller = TextEditingController();
  if(controllers.containsKey(info.type)){
    controller = controllers[info.type];
  }
  else{
    controllers[info.type] = TextEditingController();
  }

  if(info.type != TypeEnum.dates) {
    return BlocProvider<InfoCubit>(
        create: (context) => InfoCubit(),
        child: BlocBuilder<InfoCubit, InfoState>(
            builder: (context, state) {
              if (state is InfoInitial) {
                return oneInfoToShow(context, info, false, controller ?? TextEditingController());
              }
              else if (state is InfoEdit) {
                return oneInfoToShow(context, info, true, controller ?? TextEditingController());
              }
              else {
                return const SizedBox.shrink();
              }
            }
        )
    );
  }
  else{
    return BlocProvider<DateCubit>(
        create: (context) => DateCubit(),
        child: BlocBuilder<DateCubit, DateState>(
            builder: (context, state) {
              if (state is DateInitial) {
                return dateToShow(context, info, false, controller ?? TextEditingController());
              }
              else if (state is DateEdit) {
                return dateToShow(context, info, true, controller ?? TextEditingController());
              }
              else {
                return const SizedBox.shrink();
              }
            }
        )
    );
  }
}

Widget oneInfoToShow(BuildContext context, Info info, bool edit, TextEditingController controller){
  return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Row(
        children: [
          Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(iconBasedOnType(info.type), width: 35, height: 35),
              )),
          const SizedBox(width: 15),
          Expanded(child: !edit ? returnInfoToShow(info.value) : inputBasedOnType(context, info.type, controller)),
          returnCorrectIcon(context, edit, info.type)
        ],
      )
  );
}

Widget dateToShow(BuildContext context, Info info, bool edit, TextEditingController controller){
  return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Row(
        children: [
          Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(iconBasedOnType(info.type), width: 35, height: 35),
              )),
          const SizedBox(width: 15),
          Expanded(child: dateRow(context, info, edit)),
          returnCorrectIcon(context, edit, info.type)
        ],
      )
  );
}

Widget dateRow(BuildContext context, Info dates, bool edit){
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: edit ? dateEdit(context) : dateInfo(context, dates));
}

Widget returnInfoToShow(String input){
  bool isUrl = Uri.parse(input).host == '' ? false : true;

  if(!isUrl){
    return info(input);
  }
  else{
    return infoURL(input);
  }
}

Widget returnCorrectIcon(BuildContext context, bool edit, TypeEnum type){
  if(type == TypeEnum.dates && edit){
    return backFromEditIcon(context, true, type);
  }
  else if(type == TypeEnum.dates && edit == false){
    return editIcon(context, true, type);
  }
  else if(type != TypeEnum.dates && edit == false){
    return editIcon(context, false, type);
  }
  else if (type != TypeEnum.dates && edit){
    return backFromEditIcon(context, false, type);
  }
  else{
    return const SizedBox.shrink();
  }
}

Widget inputBasedOnType(BuildContext context, TypeEnum type, TextEditingController controller){

  switch(type){
    case TypeEnum.place:{
      return returnInputField(context, controller, "Zadaj miesto konania akcie", "Location");
    }

    case TypeEnum.transport:{
      return returnInputField(context, controller, "Vlo?? link na dopravu", "Transport");
    }

    case TypeEnum.accommodation:{
      return returnInputField(context, controller, "Vlo?? link na ubytovanie", "Accommodation");
    }

    case TypeEnum.estimatedAmount:{
      return returnInputField(context, controller, "Zadaj odhadovan?? cenu", "EstimatedPrice");
    }
    default: {
      return returnInputField(context, controller, "Zadaj hoci??o", "Something");
    }
  }
}

Widget returnInputField(BuildContext context, TextEditingController controller, String placeholderText, String type){

  return TextField(
    controller: controller,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
        hintText: placeholderText,
        contentPadding: const EdgeInsets.all(13)),
    style: Theme_.lightTextTheme.headline3,
  );
}

Widget info(String input){
  return Text(input, style: Theme_.lightTextTheme.headline5);
}

Widget infoURL(String input){
  return RichText(
    text: TextSpan(
        text: Uri.parse(input).host,
        style: TextStyle(
            color: Colors.white,
            fontSize: Theme_.lightTextTheme.headline5?.fontSize,
            fontWeight:
            Theme_.lightTextTheme.headline5?.fontWeight,
            decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launchURL(input);
          })
  );
}

void _launchURL(String _url) async {
  if (!await launch(_url)) {}
}

Widget participantsInitial(BuildContext context, Event_ selectedEvent) {
  return participants(context, selectedEvent);
}

Widget participantsRolled(BuildContext context, Event_ selectedEvent) {
  return Column(
    children: [
      participants(context, selectedEvent),
      Wrap(
          direction: Axis.horizontal,
          children: List<Widget>.generate(selectedEvent.votes.length, (index) {
            return userChip(context, selectedEvent.votes[index]);
          }))
    ],
  );
}

Widget userChip(BuildContext context, Vote vote) {
  return Padding(
      child: Chip(
        label: Wrap(alignment: WrapAlignment.center, children: [
          Text(
            vote.username,
            style: const TextStyle(color: Colors.black),
          ),
          const Text(" "),
          getCorrectAvatar(vote.vote)
        ]),
        backgroundColor: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 3, right: 3));
}

Widget getCorrectAvatar(VoteEnum vote) {
  if (vote == VoteEnum.yes) {
    return Image.asset("assets/icons/correct.png",
        width: 17, height: 17, alignment: Alignment.center);
  } else if (vote == VoteEnum.no) {
    return Image.asset("assets/icons/failed.png",
        width: 17, height: 17, alignment: Alignment.center);
  } else {
    return Image.asset("assets/icons/question.png",
        width: 17, height: 17, alignment: Alignment.center);
  }
}

Widget participants(BuildContext context, Event_ selectedEvent) {
  List<int> counts = selectedEvent.participantsVotes();

  bool showMore = BlocProvider.of<ParticipantsCubit>(context).showMore;

  return Row(
    children: [
      Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset("assets/icons/user-solid.png",
                width: 35, height: 35),
          )),
      const SizedBox(width: 15),
      Builder(
        builder: (context) => Row(children: [
          Text(counts[0].toString() + " ",
              style: Theme_.lightTextTheme.headline5),
          Image.asset("assets/icons/correct.png", width: 27, height: 25),
          Text(", ", style: Theme_.lightTextTheme.headline5),
          Text(counts[1].toString() + " ",
              style: Theme_.lightTextTheme.headline5),
          Image.asset("assets/icons/failed.png", width: 25, height: 25),
          Text(", ", style: Theme_.lightTextTheme.headline5),
          Text(counts[2].toString() + " ",
              style: Theme_.lightTextTheme.headline5),
          Image.asset("assets/icons/question.png", width: 25, height: 25),
          Text(" ", style: Theme_.lightTextTheme.headline5),
          RichText(
              text: TextSpan(
                  text: showMore ? "Zobrazi?? viac" : "Zobrazi?? menej",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    decoration: TextDecoration.underline,
                    fontSize: Theme_.lightTextTheme.headline3?.fontSize,
                    fontWeight: Theme_.lightTextTheme.headline3?.fontWeight,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      BlocProvider.of<ParticipantsCubit>(context)
                          .showMoreLess();
                    }))
        ]),
      )
    ],
  );
}

//TODO - zlepsit vracanie datumu z triedy Event_ a nahradit to formatovanie
List<Widget> dateInfo(BuildContext context, Info dates) {
  List<Widget> info = List.empty(growable: true);

  DateTime? startDate = dates.value[DateEnum.startDate];
  DateTime? endDate = dates.value[DateEnum.endDate];

  var formatterDate = DateFormat('dd.MM.yyyy');
  var formatterTime = DateFormat.Hm();

  if (endDate == null) {
    info.add(Text(formatterDate.format(startDate!),
        style: Theme_.lightTextTheme.headline5));
    info.add(Text(formatterTime.format(startDate),
        style: Theme_.lightTextTheme.headline5));
  } else {
    info.add(Text(
        formatterDate.format(startDate!) +
            " - " +
            formatterDate.format(endDate),
        style: Theme_.lightTextTheme.headline5));
  }

  return info;
}

Widget Unvoted(BuildContext context, Vote actualUserVote) {
  return Container(
      decoration: const BoxDecoration(
        color: Color(0xff000428),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: Column(children: [
            Text("Z????astn???? sa ?", style: Theme_.lightTextTheme.headline3),
            Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 15,
                    child: ElevatedButton(
                        onPressed: () {
                          if(actualUserVote.vote != VoteEnum.no) {
                            Vote alteredVote = actualUserVote.copy();
                            alteredVote.vote = VoteEnum.no;

                            BlocProvider.of<VotingCubit>(context)
                                .voting(alteredVote);
                          }
                        },
                        child: const Text('NIE'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Color(0xffff6666), // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ))),
                const SizedBox(width: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 15,
                    child: ElevatedButton(
                        onPressed: () {
                          if(actualUserVote.vote != VoteEnum.yes){
                            Vote alteredVote = actualUserVote.copy();
                            alteredVote.vote = VoteEnum.yes;

                            BlocProvider.of<VotingCubit>(context)
                              .voting(alteredVote);
                          }
                        },
                        child: const Text('??NO'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Color(0xff71b671), // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ))),
                const SizedBox(width: 10)
              ],
            )
          ])));
}

Widget alreadyVoted(BuildContext context, Vote actualUserVote) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 75,
      decoration: const BoxDecoration(
        color: Color(0xff000428),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Theme_.lightTextTheme.headline3?.fontSize,
                        fontWeight:
                            Theme_.lightTextTheme.headline3?.fontWeight),
                    children: <TextSpan>[
                      const TextSpan(text: 'Zahlasoval si '),
                      userVote(actualUserVote)
                    ],
                  ),
                ),
                Text('Chce?? svoj hlas zmeni?? ? ',
                    style: Theme_.lightTextTheme.headline3),
                RichText(
                    text: TextSpan(
                        text: 'Zmeni??',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: Theme_.lightTextTheme.headline3?.fontSize,
                            fontWeight:
                                Theme_.lightTextTheme.headline3?.fontWeight,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          BlocProvider.of<VotingCubit>(context)
                              .changeVote();
                        })),
              ])));
}

TextSpan userVote(Vote actualUserVote){
  if(actualUserVote.vote == VoteEnum.yes) {
    return const TextSpan(
      text: '??NO',
      style: TextStyle(color: Color(0xff71b671)));
  }
  else{
    return const TextSpan(
        text: 'NIE',
        style: TextStyle(color: Color(0xffff6666)));
  }
}

List<Widget> dateEdit(BuildContext context) {
  List<Widget> edit = List.empty(growable: true);

  DateTime actualDateTime = DateTime.now();
  DateTime endDateTime = actualDateTime.add(const Duration(days: 1825));

  bool isChecked = BlocProvider.of<DateCubit>(context).moreDayAction;

  String dateAndTime = BlocProvider.of<DateCubit>(context).dateText;

  edit.add(Row(
        children: [
           Checkbox(
              value: isChecked,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              onChanged: (bool? newValue) {
                BlocProvider.of<DateCubit>(context)
                    .updateMoreDayCheckbox();
              }),
          Text("Viacd??ov?? akcia", style: Theme_.lightTextTheme.headline3)
        ],
      ));

  edit.add(GestureDetector(
      onTap: () async {
        if (!isChecked) {
          await showDatePicker(
              context: context,
              locale: const Locale("sk", "SK"),
              initialDate: actualDateTime,
              firstDate: actualDateTime,
              lastDate: endDateTime,
              helpText: 'Vyber d??tum a ??as')
              .then((value) =>
              BlocProvider.of<DateCubit>(context)
                  .updateDate(value));

          await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.dial)
              .then((value) =>
              BlocProvider.of<DateCubit>(context)
                  .updateTime(value));
        } else {
          await showDateRangePicker(
              context: context,
              locale: const Locale("sk", "SK"),
              firstDate: actualDateTime,
              lastDate: endDateTime,
              helpText: 'Vyber d??tum a ??as')
              .then((value) =>
              BlocProvider.of<DateCubit>(context)
                  .updateDateRange(value));
        }

        BlocProvider.of<DateCubit>(context).showEditField();

      },
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5)),
          child: Row(children: [
             Padding(
              padding: EdgeInsets.all(13),
              child: Text(
                dateAndTime,
                style: Theme_.lightTextTheme.headline3,
              ),
            ),
          ])
      )));

  return edit;
}

Widget editIcon(BuildContext context, bool date, TypeEnum type){
  return Center(
    child: Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: const Icon(FontAwesomeIcons.edit),
        iconSize: 30,
        color: Colors.white,
        onPressed: () {
          if(!date) {
            BlocProvider.of<InfoCubit>(context).showEditField();
          } else{
            BlocProvider.of<DateCubit>(context).showEditField();
          }
        },
      ),
    ),
  );
}

Widget backFromEditIcon(BuildContext context, bool date, TypeEnum type){
  return Center(
    child: Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: const Icon(FontAwesomeIcons.arrowLeft),
        iconSize: 30,
        color: Colors.white,
        onPressed: () {
          if(!date) {
            BlocProvider.of<InfoCubit>(context).showInitialField();
          } else{
            BlocProvider.of<DateCubit>(context).showInitialField();
          }
        },
      ),
    ),
  );
}

String iconBasedOnType(TypeEnum type){
  switch(type){
    case TypeEnum.dates:{
      return "assets/icons/calendar.png";
    }

    case TypeEnum.place:{
      return "assets/icons/map-marker.png";
    }

    case TypeEnum.transport:{
      return "assets/icons/plane.png";
    }

    case TypeEnum.accommodation:{
      return "assets/icons/hotel.png";
    }

    case TypeEnum.estimatedAmount:{
      return "assets/icons/euro-sign.png";
    }
    default: {
      return "";
    }
  }
}