import 'package:akcosky/cubit/eventdetail/participants/participants_cubit.dart';
import 'package:akcosky/cubit/eventdetail/voting/voting_cubit.dart';
import 'package:akcosky/models/Event_.dart';
import 'package:akcosky/models/VoteEnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../cubit/authentication/authentication_cubit.dart';
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
        resizeToAvoidBottomInset: false,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ParticipantsCubit>(
              create: (context) => ParticipantsCubit(),
            ),
            BlocProvider<VotingCubit>(
              create: (context) => VotingCubit(eventRepository),
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
                            child: SingleChildScrollView(
                                child: eventInfo(context, selectedEvent)),
                          ))),
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
                          content: Text("Zmena hlasu bola uložená do databázy !"),
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

Widget eventInfo(BuildContext context, Event_ _selectedEvent) {
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
      Row(
        children: [
          Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset("assets/icons/calendar.png",
                    width: 35, height: 35),
              )),
          const SizedBox(width: 15),
          Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: dateInfo(context, selectedEvent)),
          ),
          Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.edit),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      oneRow("assets/icons/map-marker.png", selectedEvent.place),
      selectedEvent.transport != ""
          ? oneRow("assets/icons/plane.png", selectedEvent.transport)
          : const SizedBox.shrink(),
      selectedEvent.accommodation != ""
          ? oneRow("assets/icons/hotel.png", selectedEvent.accommodation)
          : const SizedBox.shrink(),
      selectedEvent.estimatedAmount != 0.0
          ? oneRow("assets/icons/euro-sign.png",
              selectedEvent.estimatedAmount.toString())
          : const SizedBox.shrink()
    ],
  );
}

Widget oneRow(String icon, String input) {
  bool isUrl = Uri.parse(input).host == '' ? false : true;

  if (isUrl) {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
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
                  child: Image.asset(icon, width: 35, height: 35),
                )),
            const SizedBox(width: 15),
            Expanded(
                child: RichText(
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
                          }))),
            Center(
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.edit),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            )
          ],
        ));
  } else {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
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
                  child: Image.asset(icon, width: 35, height: 35),
                )),
            const SizedBox(width: 15),
            Expanded(child: Text(input, style: Theme_.lightTextTheme.headline5)),
          Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.edit),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          )
      ],
    )
    );
  }
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
                  text: showMore ? "Zobraziť viac" : "Zobraziť menej",
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
List<Widget> dateInfo(BuildContext context, Event_ selectedEvent) {
  List<Widget> info = List.empty(growable: true);

  var formatterDate = DateFormat('dd.MM.yyyy');
  var formatterTime = DateFormat.Hm();

  if (selectedEvent.endDate == null) {
    info.add(Text(formatterDate.format(selectedEvent.startDate!),
        style: Theme_.lightTextTheme.headline5));
    info.add(Text(formatterTime.format(selectedEvent.startDate!),
        style: Theme_.lightTextTheme.headline5));
  } else {
    info.add(Text(
        formatterDate.format(selectedEvent.startDate!) +
            " - " +
            formatterDate.format(selectedEvent.endDate!),
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
            Text("Zúčastníš sa ?", style: Theme_.lightTextTheme.headline3),
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
                        child: const Text('ÁNO'),
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
                Text('Chceš svoj hlas zmeniť ? ',
                    style: Theme_.lightTextTheme.headline3),
                RichText(
                    text: TextSpan(
                        text: 'Zmeniť',
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
      text: 'ÁNO',
      style: TextStyle(color: Color(0xff71b671)));
  }
  else{
    return const TextSpan(
        text: 'NIE',
        style: TextStyle(color: Color(0xffff6666)));
  }
}
