import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_booking/models/event.dart';
import 'package:meta/meta.dart';
import 'package:event_booking/service/eventservice.dart';

part 'tktbooking_event.dart';
part 'tktbooking_state.dart';

class TktbookingBloc extends Bloc<TktbookingEvent, TktbookingState> {
  TktbookingBloc() : super(TktbookingInitial());

  @override
  Stream<TktbookingState> mapEventToState(
    TktbookingEvent event,
  ) async* {
    if (event is BookingSubmitted) {
      print("no of tickets -> ${event.noOfTickets}");
      //yield TktbookingComplete();
      final eventDetail = await Events().getEventByID(event.eventId);
      yield TktbookingEventLoaded(eventDetail, true);

      // } else if (event is SeatsChanged) {
      //   print("no of tickets -> ${event.value}");
      //   yield TktbookingSeatUpdate();
    } else if (event is TktbookingInitEvent) {
      final eventDetail = await Events().getEventByID(event.eventId);
      yield TktbookingEventLoaded(eventDetail, false);
    }
  }
}
