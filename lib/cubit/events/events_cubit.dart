import 'package:akcosky/resources/EventRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventRepository eventRepository;

  EventsCubit({required this.eventRepository}) : super(EventsInitial());
}
