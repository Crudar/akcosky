import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'newevent_state.dart';

class NewEventCubit extends Cubit<NewEventState> {
  NewEventCubit() : super(NewEventInitial());
}
