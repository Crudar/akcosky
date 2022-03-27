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
                     return initialNewEventPage(context);
                  }
              ),
            )
        )
    );
  }

  Widget initialNewEventPage(BuildContext context){
    int currentStep_ = BlocProvider.of<NewEventCubit>(context).stepperState;

    final actionTypes = <String>["assets/icons/bowling.png", "assets/icons/bowling.png", "assets/icons/bowling.png", "assets/icons/bowling.png"
    ,"assets/icons/bowling.png","assets/icons/bowling.png","assets/icons/bowling.png","assets/icons/bowling.png","assets/icons/bowling.png"
    ,"assets/icons/bowling.png"];

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
                  Expanded(child: ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: const Text('ĎALEJ'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(7),
                        primary: Color(0xff000428), // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
                      )
                    )
                  ),
                  const SizedBox(width: 15),
                  if (currentStep_ != 0)
                  Expanded(child:
                    ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: const Text('SPÄŤ'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(7),
                          primary: Colors.white, // <-- Button color
                          onPrimary: Color(0xff36454F), // <-- Splash color
                        )
                    ),
                  )
                ],
              ),
            );
          },
          onStepContinue: (){
            BlocProvider.of<NewEventCubit>(context).updateStepperState(currentStep_ += 1);
          },
          onStepCancel: (){
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
                child: basicInformation(context, actionTypes),
              ),
            ),
            Step(
              isActive: currentStep_ == 1,
              state: currentStep_ > 1 ? StepState.complete : StepState.indexed,
              title: const Text('Účastníci'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 1')
              ),
            ),
            Step(
              isActive: currentStep_ == 2,
              title: const Text('Dodatočné\ninformácie'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 1')
              ),
            )
        ],
      )
    );
  }

  Widget basicInformation(context, List<String> actionTypes){

    return Column(
        children: <Widget>[
          Text(
            'Názov akcie',
            style: Theme_.lightTextTheme.headline2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  prefixIcon: Icon(FontAwesomeIcons.edit, color: Colors.white)
              ),
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
          Container(margin: const EdgeInsets.only(top: 10),
            height: 60,
            child: listOfActivityTypes(context, actionTypes)
          ),
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
            /*child: ElevatedButton(
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
              ),*/
              child: GestureDetector(onTap: (){
                showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    helpText: 'Vyber dátum');
              },
                child: TextField(
                //controller: eventPlace,
                decoration: const InputDecoration(
                    hintText: 'Vyber dátum konania akcie',
                    prefixIcon: Icon(FontAwesomeIcons.calendar, color: Colors.white)
                ),
              style: Theme_.lightTextTheme.headline3,
              ),//TODO - DatePicker
              )
            )
      ]
    );
  }

  Widget listOfActivityTypes(context, List types){
    int currentSelectedActivityType = BlocProvider.of<NewEventCubit>(context).selectedActivityTypeIndex;
    String currentSelectedActivityTypeIcon = BlocProvider.of<NewEventCubit>(context).selectedActivityTypeIcon;

    return ListView.separated(
      itemBuilder: (BuildContext, index){
        final String currentItem = types[index];

        if(index != currentSelectedActivityType) {
          return ElevatedButton(
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context).updateSelectedActivityType(index, currentItem);
            },
            child: Image.asset(currentItem),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(7),
              primary: Colors.white, // <-- Button color
              onPrimary: Colors.white, // <-- Splash color
            )
        );
        }
        else{
          return ElevatedButton(
              onPressed: () {

              },
              child: Image.asset(currentItem, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(7),
                primary: const Color(0xff000428), // <-- Button color
                onPrimary: Colors.white, // <-- Splash color
              )
          );
        }
      },
      itemCount: types.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(
          width: 15,
        )
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
