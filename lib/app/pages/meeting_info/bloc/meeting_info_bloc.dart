import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'meeting_info_event.dart';

part 'meeting_info_state.dart';

class MeetingInfoBloc extends Bloc<MeetingInfoEvent, MeetingInfoState> {
  MeetingInfoBloc(
      {required MeetingsRepository meetingsRepository,
      required Meeting meeting})
      : _meetingsRepository = meetingsRepository,
        _meeting = meeting,
        super(MeetingInfoState(meeting: meeting)) {
    on<MeetingInfoSubscriptionRequested>(_onSubscriptionRequested);
    on<MeetingInfoMeetingChanged>(_onMeetingChanged);
    on<MeetingInfoMemberDeleted>(_onMemberDeleted);
    on<MeetingInfoProductDeleted>(_onProductDeleted);
  }

  final MeetingsRepository _meetingsRepository;
  final Meeting _meeting;

  Future<void> _onSubscriptionRequested(MeetingInfoSubscriptionRequested event,
      Emitter<MeetingInfoState> emit) async {
    emit(state.copyWith(status: MeetingInfoStatus.loading));
    await emit.forEach(_meetingsRepository.getMeetings(),
        onData: (List<Meeting> meetings) => state.copyWith(
            meeting:
                meetings.firstWhere((element) => element.id == _meeting.id),
            status: MeetingInfoStatus.success),
        onError: (_, __) => state.copyWith(status: MeetingInfoStatus.failure));
  }

  Future<void> _onMeetingChanged(
      MeetingInfoMeetingChanged event, Emitter<MeetingInfoState> emit) async {
    emit(state.copyWith(meeting: event.meeting));
    await _meetingsRepository.saveMeeting(event.meeting);
  }

  Future<void> _onMemberDeleted(
      MeetingInfoMemberDeleted event, Emitter<MeetingInfoState> emit) async {
    var members = state.meeting.members;
    members.remove(event.member);

    emit(state.copyWith(
        meeting: state.meeting.copyWith(members: members),
        status: MeetingInfoStatus.loading));
    try {
      await _meetingsRepository.saveMeeting(state.meeting);
      emit(
        state.copyWith(status: MeetingInfoStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MeetingInfoStatus.failure),
      );
    }
  }

  Future<void> _onProductDeleted(
      MeetingInfoProductDeleted event, Emitter<MeetingInfoState> emit) async {
    var products = state.meeting.products;
    products.remove(event.product);
    emit(state.copyWith(
      meeting: state.meeting.copyWith(products: products),
      status: MeetingInfoStatus.loading,
    ));
    try {
      await _meetingsRepository.saveMeeting(state.meeting);
      emit(
        state.copyWith(status: MeetingInfoStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MeetingInfoStatus.failure),
      );
    }
  }
}
