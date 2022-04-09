import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/models/Event_.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/events/events_cubit.dart';
import '../models/Domain/EventDomain.dart';
import '../theme.dart';

class MainUI extends StatelessWidget {
  EventRepository eventRepository = EventRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: eventRepository,
        child: BlocProvider(
          create: (context) => EventsCubit(eventRepository: eventRepository),
          child: MainUIView(),
        ));
  }
}

class MainUIView extends StatefulWidget {
  const MainUIView({Key? key}) : super(key: key);

  @override
  State<MainUIView> createState() => MainUIState();
}

class MainUIState extends State<MainUIView> {
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
      builder: (BuildContext context, AsyncSnapshot<List<Event_>> events) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xff240b36), Color(0xffc31432)])),
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
                                          icon: Icon(FontAwesomeIcons.ellipsisH,
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
                                          icon: Icon(FontAwesomeIcons.arrowLeft,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: const Icon(
                                        FontAwesomeIcons.calendarPlus,
                                        color: Colors.white,
                                        size: 40),
                                    onPressed: () async {
                                      Navigator.pushNamed(context, '/newevent',
                                              arguments:
                                                  BlocProvider.of<EventsCubit>(
                                                          context)
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
                                      style: Theme_.lightTextTheme.headline3),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: const Icon(
                                        FontAwesomeIcons.userFriends,
                                        color: Colors.white,
                                        size: 40),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/groups');
                                    },
                                  )
                                  //Icon(FontAwesomeIcons.userFriends, color: Colors.white, size: 40)
                                  ,
                                  Text("Skupiny",
                                      style: Theme_.lightTextTheme.headline3),
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
                            children: <Widget>[
                              listOfEvents(events.data ?? List.empty())
                            ],
                          ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget listOfEvents(List<Event_> events) {
    return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        final Event_ currentEvent = events[index];

        return Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: SizedBox(
              height: 100,
              child: Text(currentEvent.name)
          ),
          ),
        );
      },
      itemCount: events.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
    );
  }

  Future<List<Event_>> _getEventForUser(
      EventRepository eventRepository, String userID) async {
    List<Event_> events = await eventRepository.getEventsForUser(userID);

    return events;
  }
}
