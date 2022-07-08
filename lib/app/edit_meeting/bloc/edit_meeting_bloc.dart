import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'edit_meeting_event.dart';

part 'edit_meeting_state.dart';

class EditMeetingBloc extends Bloc<EditMeetingEvent, EditMeetingState> {
  EditMeetingBloc(
      {required MeetingsRepository meetingsRepository,
      required Meeting? initialMeeting})
      : _meetingsRepository = meetingsRepository,
        super(
          EditMeetingState(
              initialMeeting: initialMeeting,
              name: initialMeeting?.name ?? '',
              date: initialMeeting?.date ?? ''),
        ) {
    on<EditMeetingNameChanged>(_onNameChanged);
    on<EditMeetingDateChanged>(_onDateChanged);
    on<EditMeetingSubmitted>(_onSubmitted);
  }

  final MeetingsRepository _meetingsRepository;

  void _onNameChanged(
    EditMeetingNameChanged event,
    Emitter<EditMeetingState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onDateChanged(
    EditMeetingDateChanged event,
    Emitter<EditMeetingState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  Future<void> _onSubmitted(
      EditMeetingSubmitted event, Emitter<EditMeetingState> emit) async {
    emit(state.copyWith(status: EditMeetingStatus.loading));
    final meeting = (state.initialMeeting ?? Meeting(name: '', date: ''))
        .copyWith(name: state.name, date: state.date);
    try {
      await _meetingsRepository.saveMeetings(meeting);
      emit(state.copyWith(status: EditMeetingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditMeetingStatus.failure));
    }
  }
}
