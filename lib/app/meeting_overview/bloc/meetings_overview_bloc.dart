import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'meetings_overview_event.dart';

part 'meetings_overview_state.dart';

class MeetingsOverviewBloc
    extends Bloc<MeetingsOverviewEvent, MeetingsOverviewState> {
  MeetingsOverviewBloc({required MeetingsRepository meetingsRepository})
      : _meetingsRepository = meetingsRepository,
        super(const MeetingsOverviewState()) {
    on<MeetingsOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<MeetingsOverviewMeetingDeleted>(_onMeetingDeleted);
    on<MeetingsOverviewUndoDeletingRequested>(_onMeetingDeletedUndo);
  }

  final MeetingsRepository _meetingsRepository;

  Future<void> _onSubscriptionRequested(
      MeetingsOverviewSubscriptionRequested event,
      Emitter<MeetingsOverviewState> emit,
      ) async {
    emit(state.copyWith(status: () => MeetingsOverviewStatus.initial));

    await emit.forEach<List<Meeting>>(
        _meetingsRepository.getMeetings(),
        onData: (meetings) => state.copyWith(
              status: () => MeetingsOverviewStatus.success,
              meetings: () => meetings,
            ),
        onError: (_, __) =>
            state.copyWith(status: () => MeetingsOverviewStatus.failure));
  }

  Future<void> _onMeetingDeleted(
      MeetingsOverviewMeetingDeleted event,
      Emitter<MeetingsOverviewState> emit
      ) async {
    emit(state.copyWith(lastDeletedMeeting: () => event.meeting));
    await _meetingsRepository.deleteMeeting(event.meeting.id);
  }

  Future<void> _onMeetingDeletedUndo(
      MeetingsOverviewUndoDeletingRequested event,
      Emitter<MeetingsOverviewState> emit) async {
    assert(state.lastDeletedMeeting != null,
        "Last deleted meeting cannot be null.");
    final meeting = state.lastDeletedMeeting!;
    emit(state.copyWith(lastDeletedMeeting: null));
    await _meetingsRepository.saveMeetings(meeting);
  }
}
