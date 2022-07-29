part of 'meeting_result_bloc.dart';

enum MeetingResultStatus { initial, loading, success, failure }

class MeetingResultState extends Equatable {
  const MeetingResultState(
      {this.status = MeetingResultStatus.initial, required this.meeting});

  final Meeting meeting;

  final MeetingResultStatus status;

  @override
  List<Object> get props => [meeting, status];

  MeetingResultState copyWith({
    Meeting? meeting,
    MeetingResultStatus? status,
  }) {
    return MeetingResultState(
      meeting: meeting ?? this.meeting,
      status: status ?? this.status,
    );
  }
}
