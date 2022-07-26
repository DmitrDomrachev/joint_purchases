import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'new_meeting_event.dart';

part 'new_meeting_state.dart';

class NewMeetingBloc extends Bloc<NewMeetingEvent, NewMeetingState> {
  NewMeetingBloc({required MeetingsRepository meetingsRepository})
      : _meetingsRepository = meetingsRepository,
        super(NewMeetingState()) {
    on<NewMeetingNameChanged>(_onNameChanged);
    on<NewMeetingDateChanged>(_onDateChanged);
    on<NewMeetingSubmitted>(_onSubmitted);
  }

  final MeetingsRepository _meetingsRepository;

  void _onNameChanged(
      NewMeetingNameChanged event, Emitter<NewMeetingState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDateChanged(
      NewMeetingDateChanged event, Emitter<NewMeetingState> emit) {
    emit(state.copyWith(date: event.date));
  }

  Future<void> _onSubmitted(
      NewMeetingSubmitted event, Emitter<NewMeetingState> emit) async {
    emit(state.copyWith(status: NewMeetingStatus.loading));
    if (state.name.isEmpty) {
      emit(state.copyWith(status: NewMeetingStatus.failure));
    }
    final meeting =
        Meeting(name: state.name, date: state.date, members: [], products: []);
    try {
      await _meetingsRepository.saveMeeting(meeting);
      emit(state.copyWith(status: NewMeetingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: NewMeetingStatus.failure));
    }
  }
}
