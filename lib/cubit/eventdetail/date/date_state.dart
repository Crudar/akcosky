part of 'date_cubit.dart';

@immutable
abstract class DateState {
  const DateState();
}

class DateInitial extends DateState {
  const DateInitial();
}

class DateEdit extends DateState{
  const DateEdit();
}
