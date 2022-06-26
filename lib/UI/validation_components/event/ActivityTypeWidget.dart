import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import '../../../Helpers/DatePickerColor.dart';
import '../../../cubit/newevent/newevent_cubit.dart';
import '../../../models/validation/DateInput.dart';
import '../../../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityTypeWidget extends StatelessWidget {
  const ActivityTypeWidget({Key? key, required this.isError, required this.actionTypes}) : super(key: key);

  final bool isError;
  final List<String> actionTypes;

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(top: 10), height: 60, child: listOfActivityTypes(context, actionTypes));
  }

  Widget listOfActivityTypes(context, List<String> types) {
    String currentSelectedActivityTypeIcon = BlocProvider.of<NewEventCubit>(context).selectedActivityTypeIcon;

    return ListView.separated(
        itemBuilder: (BuildContext context, index) {
          final String currentItem = types[index];

          if (currentItem != currentSelectedActivityTypeIcon) {
            return ElevatedButton(
                onPressed: () {
                  BlocProvider.of<NewEventCubit>(context).updateSelectedActivityType(index, currentItem);

                  context.read<ValidationCubit>().onActivityTypeClicked();
                },
                child: Image.asset(currentItem),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(7),
                  primary: Colors.white, // <-- Button color
                  onPrimary: Colors.white, // <-- Splash color
                ));
          } else {
            return ElevatedButton(
                onPressed: () {},
                child: Image.asset(currentItem, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(7),
                  primary: const Color(0xff000428), // <-- Button color
                  onPrimary: Colors.white, // <-- Splash color
                ));
          }
        },
        itemCount: types.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 15,
        ));
  }

}
