import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import '../../../Helpers/DatePickerColor.dart';
import '../../../cubit/newevent/newevent_cubit.dart';
import '../../../models/validation/DateInput.dart';
import '../../../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DateInputWidget extends StatelessWidget {
  const DateInputWidget({Key? key, required this.isError}) : super(key: key);

  final bool isError;

  @override
  Widget build(BuildContext context) {
    bool isChecked = BlocProvider.of<NewEventCubit>(context).moreDayAction;

    return Column(children: [checkBox(context, isChecked), datePicker(context, isChecked)]);
  }

  Widget datePicker(BuildContext context, bool isChecked) {
    DateTime actualDateTime = DateTime.now();
    DateTime endDateTime = actualDateTime.add(const Duration(days: 1825));

    return GestureDetector(
      onTap: () async {
        context.read<ValidationCubit>().onDateUnClicked();

        if (!isChecked) {
          await showDatePicker(
                  context: context,
                  locale: const Locale("sk", "SK"),
                  initialDate: actualDateTime,
                  firstDate: actualDateTime,
                  lastDate: endDateTime,
                  helpText: 'Vyber dátum a čas')
              .then((value) {
                BlocProvider.of<NewEventCubit>(context).updateDate(value);

                if(value != null) {
                  context.read<ValidationCubit>().onDateClicked();
                }
              });

          await showTimePicker(context: context, initialTime: TimeOfDay.now(), initialEntryMode: TimePickerEntryMode.dial)
              .then((value) => BlocProvider.of<NewEventCubit>(context).updateTime(value));
        } else {
          await showDateRangePicker(
                  context: context,
                  locale: const Locale("sk", "SK"),
                  firstDate: actualDateTime,
                  lastDate: endDateTime,
                  helpText: 'Vyber dátum a čas')
              .then((value) {
                BlocProvider.of<NewEventCubit>(context).updateDateRange(value);

                if(value != null) {
                  context.read<ValidationCubit>().onDateClicked();
                }

              });
        }
      },
      child: dateShow());
  }

  Widget dateShow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: BlocBuilder<ValidationCubit, ValidationState>(
        builder: (context, state) {
          String dateAndTime = BlocProvider.of<NewEventCubit>(context).dateText;

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                decoration: BoxDecoration(border: Border.all(color: !isError ? Colors.white : Colors.yellow), borderRadius: BorderRadius.circular(5)),
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(FontAwesomeIcons.calendar, color: Colors.white),
                  ),
                  Text(
                    dateAndTime,
                    style: Theme_.lightTextTheme.headline3,
                  ),
                ])),
            isError ? errorHint() : SizedBox.shrink()
          ]);
        },
      ),
    );
  }

  Widget checkBox(BuildContext context, bool isChecked) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Checkbox(
                value: isChecked,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                onChanged: (bool? newValue) {
                  BlocProvider.of<NewEventCubit>(context).updateMoreDayCheckbox();
                }),
            Text("Viacdňová akcia", style: Theme_.lightTextTheme.headline3)
          ],
        ));
  }

  Widget errorHint() {
    return Padding(
        padding: EdgeInsets.only(left: 17, top: 5),
        child: Text("Dátum musí byť zvolený", style: Theme_.lightTextTheme.headline3?.copyWith(color: Colors.yellow, fontSize: 11)));
  }
}
