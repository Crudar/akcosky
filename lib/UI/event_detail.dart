import 'package:akcosky/models/Event_.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme.dart';

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
      body: Container(
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
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.arrowLeft,
                        color: Colors.white, size: 30)),
              ),
              Positioned.fill(
                  top: 270,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 500,
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
                    child: Padding(padding: const EdgeInsets.all(15),
                      child: eventInfo(context, selectedEvent),
                    ) 
                  )),
              Positioned(
                  bottom: 0,
                  child: voting(context))
            ],
          ))),
    );
  }
}

Widget eventInfo(BuildContext context, Event_ _selectedEvent){
  Event_ selectedEvent = _selectedEvent;
  
  return Column(
    children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedEvent.name, style: Theme_.lightTextTheme.headline2),
              Text("Vytvoril: " + selectedEvent.createdBy, style: Theme_.lightTextTheme.headline3),
            ],
          ),
          Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(8.0)),
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset("assets/icons/activityTypes/" + selectedEvent.type + ".png",
                width: 55,
                height: 55),
              )
            ),
        ]
        )
      ],
  );
}

Widget voting(BuildContext context){
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
            Text("Zúčastníš sa ?",
                style: Theme_.lightTextTheme.headline3),
            Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                    width:
                    MediaQuery.of(context).size.width / 2 -
                        15,
                    child: ElevatedButton(
                        onPressed: () => print("tapped"),
                        child: const Text('NIE'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Color(
                              0xffff6666), // <-- Button color
                          onPrimary:
                          Colors.white, // <-- Splash color
                        ))),
                const SizedBox(width: 10),
                SizedBox(
                    width:
                    MediaQuery.of(context).size.width / 2 -
                        15,
                    child: ElevatedButton(
                        onPressed: () => print("tapped"),
                        child: const Text('ÁNO'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Color(
                              0xff71b671), // <-- Button color
                          onPrimary:
                          Colors.white, // <-- Splash color
                        ))),
                const SizedBox(width: 10)
              ],
            )
          ]))
  );
}
