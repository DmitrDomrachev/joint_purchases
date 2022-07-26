part of 'meetings_overview_bloc.dart';

enum MeetingsOverviewStatus { initial, loading, success, failure }

class MeetingsOverviewState extends Equatable {
  const MeetingsOverviewState(
      {this.status = MeetingsOverviewStatus.initial,
      this.meetings = const [],
      this.lastDeletedMeeting});

  final MeetingsOverviewStatus status;
  final List<Meeting> meetings;
  final Meeting? lastDeletedMeeting;


  MeetingsOverviewState copyWith({
    MeetingsOverviewStatus Function()? status,
    List<Meeting> Function()? meetings,
    Meeting? Function()? lastDeletedMeeting,
  }) {
    return MeetingsOverviewState(
      status: status != null ? status() : this.status,
      meetings: meetings != null ? meetings() : this.meetings,
      lastDeletedMeeting: lastDeletedMeeting != null
          ? lastDeletedMeeting()
          : this.lastDeletedMeeting,
    );
  }

  @override
  List<Object?> get props => [
    status,
    meetings,
    lastDeletedMeeting,
  ];
}
