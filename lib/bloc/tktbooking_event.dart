part of 'tktbooking_bloc.dart';

@immutable
abstract class TktbookingEvent {}

class TktbookingInitEvent extends TktbookingEvent {
  final String eventId;

  TktbookingInitEvent(this.eventId);
}

class BookingSubmitted extends TktbookingEvent {
  final int noOfTickets;
  final String eventId;

  BookingSubmitted(this.noOfTickets, this.eventId);
}

class SeatsChanged extends TktbookingEvent {
  final int value;

  SeatsChanged(this.value);
}
