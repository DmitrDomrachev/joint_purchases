part of 'edit_meeting_bloc.dart';

abstract class EditMeetingEvent extends Equatable {
  const EditMeetingEvent();

  @override
  List<Object> get props => [];
}

class EditMeetingNameChanged extends EditMeetingEvent {
  const EditMeetingNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EditMeetingDateChanged extends EditMeetingEvent {
  const EditMeetingDateChanged(this.date);

  final String date;

  @override
  List<Object> get props => [date];
}

class EditMeetingSubmitted extends EditMeetingEvent {
  const EditMeetingSubmitted();
}

