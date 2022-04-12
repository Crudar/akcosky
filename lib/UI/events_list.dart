import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/models/Event_.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/events/events_cubit.dart';
import '../theme.dart';
import 'package:timelines/timelines.dart';

class EventsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    EventRepository eventRepository = RepositoryProvider.of<EventRepository>(context);

    return BlocProvider(
          create: (context) => EventsCubit(eventRepository: eventRepository),
          child: EventsListView(),
        );
  }
}

class EventsListView extends StatefulWidget {
  const EventsListView({Key? key}) : super(key: key);

  @override
  State<EventsListView> createState() => EventsListState();
}

class EventsListState extends State<EventsListView> {
  bool menuVisible = false;

  showMenu() {
    setState(() {
      menuVisible = !menuVisible;
    });
  }

  @override
  Widget build(context) {
    EventRepository eventRepository =
        BlocProvider.of<EventsCubit>(context).eventRepository;
    String userID = BlocProvider.of<AuthenticationCubit>(context)
        .userRepository
        .getUser()
        .id;

    return FutureBuilder(
      future: _getEventForUser(eventRepository, userID),
      builder: (BuildContext context,
          AsyncSnapshot<Map<int?, List<Event_>>> events) {
        return SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Visibility(
                                  visible: !menuVisible,
                                  child: Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                showMenu();
                                              },
                                              icon: Icon(
                                                  FontAwesomeIcons.ellipsisH,
                                                  color: Colors.white,
                                                  size: 30))))),
                              Visibility(
                                  visible: menuVisible,
                                  child: Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                showMenu();
                                              },
                                              icon: Icon(
                                                  FontAwesomeIcons.arrowLeft,
                                                  color: Colors.white,
                                                  size: 30))))),
                              Expanded(
                                  flex: 8,
                                  child: Text("Akcošky",
                                      style: Theme_.lightTextTheme.headline2))
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: menuVisible,
                            child: Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  //color: Color(0xff0b3236),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: const Icon(
                                            FontAwesomeIcons.calendarPlus,
                                            color: Colors.white,
                                            size: 40),
                                        onPressed: () async {
                                          Navigator.pushNamed(
                                              context, '/newevent',
                                              arguments: BlocProvider.of<
                                                  EventsCubit>(context)
                                                  .eventRepository)
                                              .then((value) {
                                            if (value != null) {
                                              bool success = value as bool;

                                              if (success) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Akcia bola úspešne vytvorená!")));
                                              }
                                            }
                                          });
                                        },
                                      )
                                      //Icon(FontAwesomeIcons.calendarPlus, color: Colors.white, size: 40)
                                      ,
                                      Text("Vytvor akciu",
                                          textAlign: TextAlign.center,
                                          style:
                                          Theme_.lightTextTheme.headline3),
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: const Icon(
                                            FontAwesomeIcons.userFriends,
                                            color: Colors.white,
                                            size: 40),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/groups');
                                        },
                                      )
                                      //Icon(FontAwesomeIcons.userFriends, color: Colors.white, size: 40)
                                      ,
                                      Text("Skupiny",
                                          style:
                                          Theme_.lightTextTheme.headline3),
                                      const SizedBox(height: 15)
                                    ],
                                  ),
                                )),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[listOfEvents(events.data)],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
            );
      },
    );
  }

  Widget listOfEvents(Map<int?, List<Event_>>? events) {
    /*return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        final Event_ currentEvent = events[index];

        return Card(
              color: const Color(0xff000000),
              child: InkWell(
                splashColor: const Color(0xff000000),
                onTap: () {
                  debugPrint('Card tapped.');
                },
                child: Wrap(children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          //child: Image.asset(currentEvent.type)
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(currentEvent.type),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentEvent.name,
                                    style: Theme_.lightTextTheme.headline6),
                                const SizedBox(height: 10),
                                Row(children: [
                                  const Icon(FontAwesomeIcons.mapMarkerAlt,
                                      color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(currentEvent.place,
                                      style: Theme_.lightTextTheme.headline3),
                                  const SizedBox(width: 5),
                                  const Icon(FontAwesomeIcons.userAlt,
                                      color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(
                                      currentEvent
                                              .comingParticipants()
                                              .toString() +
                                          "/" +
                                          currentEvent.votes.length.toString(),
                                      style: Theme_.lightTextTheme.headline3)
                                ]),
                              ],
                            )),
                        Spacer(),
                        Container(
                          //child: Image.asset(currentEvent.type)
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Text(currentEvent.startDate?.day.toString() ?? "",
                                  style: Theme_.lightTextTheme.headline5),
                              Text(currentEvent.getMonth3Letters(),
                                  style: Theme_.lightTextTheme.headline5),
                              Text(currentEvent.getTime(),
                                  style: Theme_.lightTextTheme.headline5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ));
      },
      itemCount: events.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
    );*/
    List<Widget> list = List.empty(growable: true);

    if (events != null) {
      events.forEach((key, value) {
        list.add(Padding(
            padding: const EdgeInsets.only(left: 5),
            child:
            Text(key.toString(), style: Theme_.lightTextTheme.headline2)));

        list.add(timelineForYear(value));
      });
    }
    return Wrap(children: list);
  }

  Widget timelineForYear(List<Event_> events) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0.01,
        indicatorTheme: const IndicatorThemeData(color: Color(0xff000428)),
        connectorTheme: const ConnectorThemeData(color: Color(0xff000428)),
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        connectionDirection: ConnectionDirection.before,
        contentsBuilder: (context, index) {
          final Event_ currentEvent = events[index];

          return Card(
            color: const Color(0xff000000),
            child: InkWell(
                splashColor: const Color(0xff000000),
                onTap: () {
                  debugPrint('Card tapped.');
                },
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          //child: Image.asset(currentEvent.type)
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(currentEvent.type),
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                        ),
                        Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentEvent.name,
                                    style: Theme_.lightTextTheme.headline6),
                                const SizedBox(height: 10),
                                Row(children: [
                                  const Icon(FontAwesomeIcons.mapMarkerAlt,
                                      color: Colors.white),
                                  const SizedBox(width: 5),
                                  Flexible(child: Text(currentEvent.place,
                                      style: Theme_.lightTextTheme.headline3)),
                                  const SizedBox(width: 5),
                                  const Icon(FontAwesomeIcons.userAlt,
                                      color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(
                                      currentEvent
                                          .comingParticipants()
                                          .toString() +
                                          "/" +
                                          currentEvent.votes.length.toString(),
                                      style: Theme_.lightTextTheme.headline3)
                                ]),
                              ],
                            ))),
                        Container(
                          //child: Image.asset(currentEvent.type)
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0)),
                              color: Colors.white,
                            ),
                            child: Center(
                                child: Text(currentEvent.getDate(),
                                    style: Theme_.lightTextTheme.headline5,
                                    textAlign: TextAlign.center))),
                      ],
                    ),
                  ),
                ]
                )),
          );
        },
        connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
        indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
        itemCount: events.length,
      ),
    );
  }

  Future<Map<int?, List<Event_>>> _getEventForUser(
      EventRepository eventRepository, String userID) async {
    Map<int?, List<Event_>> events =
    await eventRepository.getEventsForUser(userID);

    return events;
  }
}