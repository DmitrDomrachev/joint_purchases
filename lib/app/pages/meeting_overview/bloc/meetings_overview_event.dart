part of 'meetings_overview_bloc.dart';

abstract class MeetingsOverviewEvent extends Equatable {
  const MeetingsOverviewEvent();

  @override
  List<Object> get props => [];
}

class MeetingsOverviewSubscriptionRequested extends MeetingsOverviewEvent {
  const MeetingsOverviewSubscriptionRequested();
}

class MeetingsOverviewMeetingDeleted extends MeetingsOverviewEvent {
  const MeetingsOverviewMeetingDeleted(this.meeting);

  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

class MeetingsOverviewUndoDeletingRequested extends MeetingsOverviewEvent {
  const MeetingsOverviewUndoDeletingRequested();
}
