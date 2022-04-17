part of 'main_ui_cubit.dart';

@immutable
abstract class MainUiState {
  const MainUiState();
}

class MainUiStateNavigate extends MainUiState {
  final NavbarItem navbarItem;
  final int index;

  const MainUiStateNavigate(this.navbarItem, this.index);
}
