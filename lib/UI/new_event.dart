import 'package:akcosky/cubit/newevent/newevent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NewEventCubit(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
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
                  builder: (context, state){
                    return initialNewEventPage();
                  }
              ),
            )
        )
    );
  }

  Widget initialNewEventPage(){
    return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Nová akcia',
              style: Theme_.lightTextTheme.headline1,
            ),
          ),
          Text(
            'Názov akcie',
            style: Theme_.lightTextTheme.headline2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Popis/Plán akcie',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Typ akcie',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          /*
            TU BUDE PRESMEROVANIE NA POPUP KDE SA VYBERIE IKONA
             */
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Miesto konania',
              style: Theme_.lightTextTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            child: ElevatedButton(
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
              ),
              /*child: TextField(
              controller: eventPlace,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: 'Vyber dátum konania akcie',
                  prefixIcon: Icon(FontAwesomeIcons.calendar, color: Colors.white)
              ),
              style: Theme_.lightTextTheme.headline3,
            ),//TODO - DatePicker*/
            )
        ]
    );
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
