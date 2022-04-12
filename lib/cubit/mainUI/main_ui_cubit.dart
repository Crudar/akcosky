import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'main_ui_state.dart';

enum NavbarItem {akcie, vytvor_akciu, skupiny}

class MainUiCubit extends Cubit<MainUiState> {
  MainUiCubit() : super(const MainUiStateNavigate(NavbarItem.akcie, 0));

  void getNavBarItem(NavbarItem navbarItem){
    switch (navbarItem) {
      case NavbarItem.akcie:
        emit(const MainUiStateNavigate(NavbarItem.akcie, 0));
        break;
      case NavbarItem.vytvor_akciu:
        emit(const MainUiStateNavigate(NavbarItem.vytvor_akciu, 1));
        break;
      case NavbarItem.skupiny:
        emit(const MainUiStateNavigate(NavbarItem.skupiny, 2));
        break;
    }
  }
}
