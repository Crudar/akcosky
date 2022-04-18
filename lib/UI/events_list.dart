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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 5),
                      child: Text("Akcošky", style: Theme_.lightTextTheme.headline2)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[listOfEvents(events.data)],
                    )
                ],
              ),
          ),
        );
      },
    );
  }

  Widget listOfEvents(Map<int?, List<Event_>>? events) {
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
                  Navigator.pushNamed(
                      context, '/detail',
                      arguments: currentEvent);
                },
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Center(child: Image.asset("assets/icons/activityTypes/" + currentEvent.type + ".png",
                            width: 55,
                            height: 55)
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
                                    style: Theme_.lightTextTheme.headline5?.copyWith(
                                      color: Colors.black
                                    ),
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