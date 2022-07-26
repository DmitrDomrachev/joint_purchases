part of 'new_meeting_bloc.dart';

class NewMeetingEvent extends Equatable {
  const NewMeetingEvent();

  @override
  List<Object?> get props => [];
}

class NewMeetingNameChanged extends NewMeetingEvent {
  const NewMeetingNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class NewMeetingDateChanged extends NewMeetingEvent {
  const NewMeetingDateChanged(this.date);

  final String date;

  @override
  List<Object> get props => [date];
}

class NewMeetingSubmitted extends NewMeetingEvent {
  const NewMeetingSubmitted();
}
