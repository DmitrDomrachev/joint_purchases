part of 'meeting_info_bloc.dart';

class MeetingInfoEvent extends Equatable {
  const MeetingInfoEvent();

  @override
  List<Object?> get props => [];
}

class MeetingInfoSubscriptionRequested extends MeetingInfoEvent {
  const MeetingInfoSubscriptionRequested();
}

class MeetingInfoMeetingChanged extends MeetingInfoEvent {
  const MeetingInfoMeetingChanged(this.meeting);

  final Meeting meeting;

  @override
  List<Object?> get props => [meeting];
}

class MeetingInfoMemberDeleted extends MeetingInfoEvent {
  const MeetingInfoMemberDeleted(this.member);

  final Member member;

  @override
  List<Object?> get props => [member];
}

class MeetingInfoProductDeleted extends MeetingInfoEvent {
  const MeetingInfoProductDeleted(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

