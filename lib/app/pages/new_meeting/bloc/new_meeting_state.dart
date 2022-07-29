part of 'new_meeting_bloc.dart';

enum NewMeetingStatus { initial, loading, success, failure }

class NewMeetingState extends Equatable {
  const NewMeetingState({
    this.status = NewMeetingStatus.initial,
    this.name = '',
    this.date = '',
  });

  final NewMeetingStatus status;
  final String name;
  final String date;

  @override
  List<Object> get props => [status, name, date];

  NewMeetingState copyWith({
    NewMeetingStatus? status,
    String? name,
    String? date,
  }) {
    return NewMeetingState(
      status: status ?? this.status,
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }
}
