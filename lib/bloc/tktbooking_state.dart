part of 'tktbooking_bloc.dart';

@immutable
abstract class TktbookingState {}

class TktbookingInitial extends TktbookingState {}

class TktbookingEventLoaded extends TktbookingState {
  final Event event;
  final bool isComplete;
  TktbookingEventLoaded(this.event, this.isComplete);
}

//class TktbookingSeatUpdate extends TktbookingState {}

// class TktbookingComplete extends TktbookingState {
//     final Event event;

//   TktbookingComplete(this.event);

// }
