part of 'meeting_info_bloc.dart';

enum MeetingInfoStatus { initial, loading, success, failure }

class MeetingInfoState extends Equatable {
  const MeetingInfoState(
      {this.status = MeetingInfoStatus.initial, required this.meeting});

  final Meeting meeting;

  final MeetingInfoStatus status;



  @override
  List<Object> get props => [meeting, status];

  MeetingInfoState copyWith({
    Meeting? meeting,
    MeetingInfoStatus? status,
  }) {
    return MeetingInfoState(
      meeting: meeting ?? this.meeting,
      status: status ?? this.status,
    );
  }
}
