import 'package:akcosky/UI/validation_components/PasswordInputWidget.dart';
import 'package:akcosky/UI/validation_components/PasswordInputWidgetWithCubit.dart';
import 'package:akcosky/UI/validation_components/UsernameInputWidget.dart';
import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/models/validation/StringInput.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:akcosky/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../cubit/newevent/newevent_cubit.dart';
import '../../../cubit/validation/validation_cubit.dart';
import '../../../models/Group.dart';
import '../../../models/UserChip.dart';

class ParticipantsPickerWidget extends StatelessWidget {
  const ParticipantsPickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Group> groups = BlocProvider.of<AuthenticationCubit>(context).userRepository.getUser().groups;
    Group selectedGroup = BlocProvider.of<NewEventCubit>(context).selectedGroup;
    Map<String, UserChip> participants = BlocProvider.of<NewEventCubit>(context).usersFromSelectedGroup;
    bool chooseAll_ = BlocProvider.of<NewEventCubit>(context).chooseAll;

    return BlocBuilder<ValidationCubit, ValidationState>(
        builder: (context, state)
    {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Vyber skupinu", style: Theme_.lightTextTheme.headline2)),
          Wrap(direction: Axis.horizontal, children: returnUserChips(context, groups, selectedGroup)),
          if (selectedGroup.id != "") Center(child: Text("Vyber účastníkov", style: Theme_.lightTextTheme.headline2)),
          selectAll(context, chooseAll_, selectedGroup.id),
          Wrap(
              direction: Axis.horizontal,
              children: List<Widget>.generate(participants.length, (index) {
                return userChip(context, participants.values.elementAt(index));
              })),
        ],
      );
    });
  }

  List<Widget> returnUserChips(BuildContext context, Map<String, Group> groups, Group selectedGroup) {
    List<Widget> widgets = List.empty(growable: true);
    groups.forEach((key, value) => widgets.add(groupChip(context, value, selectedGroup)));

    return widgets;
  }

  Widget userChip(BuildContext context, UserChip userChip) {
    if (userChip.selected) {
      return Padding(
          child: ActionChip(
              label: Text(
                userChip.user.login,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xff000428),
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context).updateSelectedUser(userChip.user.id);

                int participantsCount = BlocProvider.of<NewEventCubit>(context).getCountOfWantedParticipants();

                context.read<ValidationCubit>().onParticipantClicked(participantsCount);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    } else {
      return Padding(
          child: ActionChip(
              label: Text(
                userChip.user.login,
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context).updateSelectedUser(userChip.user.id);

                int participantsCount = BlocProvider.of<NewEventCubit>(context).getCountOfWantedParticipants();

                context.read<ValidationCubit>().onParticipantClicked(participantsCount);

              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    }
  }

  Widget groupChip(BuildContext context, Group group, Group selectedGroup) {
    if (group.id == selectedGroup.id) {
      return Padding(
          child: ActionChip(
              label: Text(
                group.title,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xff000428),
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context).updateSelectedGroup(group);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    } else {
      return Padding(
          child: ActionChip(
              label: Text(
                group.title,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                BlocProvider.of<NewEventCubit>(context).updateSelectedGroup(group);
              }),
          padding: const EdgeInsets.only(left: 3, right: 3));
    }
  }

  Widget selectAll(BuildContext context, chooseAll_, String selectedGroup) {
    if (selectedGroup != "") {
      if (chooseAll_) {
        return ActionChip(
            avatar: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            label: const Text(
              "Vyber všetkých",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xff000428),
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context).updateAllUsersInSelectedGroup();
            });
      } else {
        return ActionChip(
            avatar: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            label: const Text(
              "Vyber všetkých",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              BlocProvider.of<NewEventCubit>(context).updateAllUsersInSelectedGroup();
            });
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
