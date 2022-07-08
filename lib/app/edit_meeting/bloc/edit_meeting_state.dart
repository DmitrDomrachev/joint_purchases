part of 'edit_meeting_bloc.dart';

enum EditMeetingStatus { initial, loading, success, failure }

extension EditMeetingStateX on EditMeetingStatus {
  bool get isLoadingOrSuccess =>
      [EditMeetingStatus.loading, EditMeetingStatus.success].contains(this);
}

class EditMeetingState extends Equatable {
  const EditMeetingState(
      {this.status = EditMeetingStatus.initial,
      this.initialMeeting,
      this.name = '',
      this.date = ''});

  final EditMeetingStatus status;
  final Meeting? initialMeeting;
  final String name;
  final String date;

  bool get isNewMeeting => initialMeeting == null;

  @override
  List<Object?> get props => [status, initialMeeting, name, date];

  EditMeetingState copyWith({
    EditMeetingStatus? status,
    Meeting? initialMeeting,
    String? name,
    String? date,
  }) {
    return EditMeetingState(
      status: status ?? this.status,
      initialMeeting: initialMeeting ?? this.initialMeeting,
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }
}
