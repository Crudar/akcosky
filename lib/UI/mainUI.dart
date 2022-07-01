import 'package:akcosky/UI/events_list.dart';
import 'package:akcosky/UI/new_event.dart';
import 'package:akcosky/cubit/mainUI/main_ui_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/events/events_cubit.dart';
import '../theme.dart';
import 'package:timelines/timelines.dart';

import 'events_list_shimmer.dart';
import 'groups.dart';

class MainUI extends StatefulWidget {
  const MainUI({Key? key}) : super(key: key);

  @override
  State<MainUI> createState() => _MainUI();
}

class _MainUI extends State<MainUI> {
  @override
  Widget build(context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar:
            BlocBuilder<MainUiCubit, MainUiState>(builder: (context, state) {
          state as MainUiStateNavigate;

          return BottomNavigationBar(
              currentIndex: state.index,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.greenAccent,
              unselectedItemColor: Colors.grey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.calendar, color: Colors.white),
                  activeIcon: Icon(FontAwesomeIcons.calendar, color: Colors.greenAccent),
                  label: 'Akcie',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.plusCircle, color: Colors.white),
                  activeIcon: Icon(FontAwesomeIcons.plusCircle, color: Colors.greenAccent),
                  label: 'Vytvor akciu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.userFriends, color: Colors.white),
                  activeIcon: Icon(FontAwesomeIcons.userFriends, color: Colors.greenAccent),
                  label: 'Skupiny',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  BlocProvider.of<MainUiCubit>(context)
                      .getNavBarItem(NavbarItem.akcie);
                } else if (index == 1) {
                  BlocProvider.of<MainUiCubit>(context)
                      .getNavBarItem(NavbarItem.vytvor_akciu);
                } else if (index == 2) {
                  BlocProvider.of<MainUiCubit>(context)
                      .getNavBarItem(NavbarItem.skupiny);
                }
              });
        }),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff240b36), Color(0xffc31432)])),
          child: BlocBuilder<MainUiCubit, MainUiState>(
              builder: (context, state) {
            state as MainUiStateNavigate;

            if (state.navbarItem == NavbarItem.akcie) {
              return EventsList();
              //return EventsListShimmer();
            } else if (state.navbarItem == NavbarItem.vytvor_akciu) {
              return NewEvent();
            } else if (state.navbarItem == NavbarItem.skupiny) {
              return const Groups();
            }
            return Container();
          })));
  }
}
