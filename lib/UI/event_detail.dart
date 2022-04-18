import 'package:akcosky/cubit/eventdetail/participants/participants_cubit.dart';
import 'package:akcosky/models/Event_.dart';
import 'package:akcosky/models/VoteEnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/Vote.dart';
import '../models/VoteEnum.dart';
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(create: (context) => ParticipantsCubit(),
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
                        image: AssetImage("assets/icons/activityHeaders/" + selectedEvent.type + ".jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              Positioned(
                left: 15,
                top: 15,
                child: IconButton(onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 30)),
              ),
              Positioned.fill(
                  top: 270,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xff4f0c2f), Color(0xffc31432)])),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 85),
                        child: SingleChildScrollView(child: eventInfo(context, selectedEvent)),
                      )
                  )
              ),
              Positioned(bottom: 0, child: voting(context))
            ],
          ))),
    )
    );
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
                Text("Vytvoril: " + selectedEvent.createdBy, style: Theme_.lightTextTheme.headline3),
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
              child: Image.asset("assets/icons/activityTypes/" + selectedEvent.type + ".png", width: 55, height: 55),
            )),
      ]),
      Text(selectedEvent.description, style: Theme_.lightTextTheme.headline3),
      const SizedBox(height: 15),
      BlocBuilder<ParticipantsCubit, ParticipantsState>(
        builder: (context, state) {
          if(state is ParticipantsInitial) {
            return participantsInitial(context, selectedEvent);
          }
          else if (state is ParticipantsShowMore){
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
                child: Image.asset("assets/icons/calendar.png", width: 35, height: 35),
              )),
          const SizedBox(width: 15),
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: dateInfo(context, selectedEvent))
        ],
      ),
      oneRow("assets/icons/map-marker.png", selectedEvent.place),
      selectedEvent.transport != "" ? oneRow("assets/icons/plane.png", selectedEvent.transport) : const SizedBox.shrink(),
      selectedEvent.accommodation != "" ? oneRow("assets/icons/hotel.png", selectedEvent.accommodation) : const SizedBox.shrink(),
      selectedEvent.estimatedAmount != 0.0 ? oneRow("assets/icons/euro-sign.png", selectedEvent.estimatedAmount.toString()) : const SizedBox.shrink(),
    ],
  );
}

Widget oneRow(String icon, String input){
  bool isUrl = Uri.parse(input).host == '' ? false : true;

  if(isUrl) {
    return Padding(padding: const EdgeInsets.only(top: 15),
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
          Expanded(child: RichText(
              text: TextSpan(
                  text: Uri.parse(input).host,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme_.lightTextTheme.headline5?.fontSize,
                    fontWeight: Theme_.lightTextTheme.headline5?.fontWeight,
                    decoration: TextDecoration.underline
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL(input);
                    }
              )
          ))
        ],
      )
    );
  }
  else{
    return Padding(padding: const EdgeInsets.only(top: 15),
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
            Expanded(child: Text(input, style: Theme_.lightTextTheme.headline5))
          ],
        )
    );
  }
}

void _launchURL(String _url) async {
  if (!await launch(_url)) {}
}

Widget participantsInitial(BuildContext context, Event_ selectedEvent){
  return participants(context, selectedEvent);
}

Widget participantsRolled(BuildContext context, Event_ selectedEvent){
  return Column(
    children: [
      participants(context, selectedEvent),
      Wrap(direction: Axis.horizontal, children: List<Widget>.generate(selectedEvent.votes.length, (index)
      {
        return userChip(context, selectedEvent.votes[index]);
      }) )
    ],
  );
}

Widget userChip(BuildContext context, Vote vote) {
  return Padding(
      child: Chip(
        label: Wrap(alignment: WrapAlignment.center,
            children: [
              Text(
                vote.userID,
                style: const TextStyle(color: Colors.black),
              ),
              const Text(" "),
              getCorrectAvatar(vote.vote)
          ]
        ),
        backgroundColor: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 3, right: 3)
  );
}

Widget getCorrectAvatar(VoteEnum vote){
  if(vote == VoteEnum.yes){
    return Image.asset("assets/icons/correct.png", width: 17, height: 17, alignment: Alignment.center);
  }
  else if(vote == VoteEnum.no){
    return Image.asset("assets/icons/failed.png", width: 17, height: 17, alignment: Alignment.center);
  }
  else{
    return Image.asset("assets/icons/question.png", width: 17, height: 17, alignment: Alignment.center);
  }
}

Widget participants(BuildContext context, Event_ selectedEvent){
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
            child: Image.asset("assets/icons/user-solid.png", width: 35, height: 35),
          )),
      const SizedBox(width: 15),
      Builder(
        builder: (context) => Row(children: [
          Text(counts[0].toString() + " ", style: Theme_.lightTextTheme.headline5),
          Image.asset("assets/icons/correct.png", width: 27, height: 25),
          Text(", ", style: Theme_.lightTextTheme.headline5),
          Text(counts[1].toString() + " ", style: Theme_.lightTextTheme.headline5),
          Image.asset("assets/icons/failed.png", width: 25, height: 25),
          Text(", ", style: Theme_.lightTextTheme.headline5),
          Text(counts[2].toString() + " ", style: Theme_.lightTextTheme.headline5),
          Image.asset("assets/icons/question.png", width: 25, height: 25),
          Text(" ", style: Theme_.lightTextTheme.headline5),
          RichText(
            text: TextSpan(
                  text: showMore ? "Zobraziť viac" : "Zobraziť menej",
                  style: TextStyle(
                    color: const Color(0xff000428),
                    fontSize: Theme_.lightTextTheme.headline3?.fontSize,
                    fontWeight: Theme_.lightTextTheme.headline3?.fontWeight,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      BlocProvider.of<ParticipantsCubit>(context).showMoreLess();
                    }
                  )
            )
          ]
        ),
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
    info.add(Text(formatterDate.format(selectedEvent.startDate!), style: Theme_.lightTextTheme.headline5));
    info.add(Text(formatterTime.format(selectedEvent.startDate!), style: Theme_.lightTextTheme.headline5));
  } else {
    info.add(Text(formatterDate.format(selectedEvent.startDate!) + " - " + formatterDate.format(selectedEvent.endDate!),
        style: Theme_.lightTextTheme.headline5));
  }

  return info;
}

Widget voting(BuildContext context) {
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
                        onPressed: () => print("tapped"),
                        child: const Text('NIE'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Color(0xffff6666), // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ))),
                const SizedBox(width: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 15,
                    child: ElevatedButton(
                        onPressed: () => print("tapped"),
                        child: const Text('ÁNO'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Color(0xff71b671), // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ))),
                const SizedBox(width: 10)
              ],
            )
          ])));
}
