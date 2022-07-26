import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'edit_member_event.dart';

part 'edit_member_state.dart';

class EditMemberBloc extends Bloc<EditMemberEvent, EditMemberState> {
  EditMemberBloc(
      {required MeetingsRepository meetingsRepository,
      required Meeting meeting})
      : _meetingsRepository = meetingsRepository,
        _meeting = meeting,
        super(EditMemberState()) {
    on<EditMemberNameChanged>(_onNameChanged);
    on<EditMemberSubmitted>(_onSubmitted);
  }

  final MeetingsRepository _meetingsRepository;
  final Meeting _meeting;


  void _onNameChanged(
      EditMemberNameChanged event, Emitter<EditMemberState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSubmitted(
      EditMemberSubmitted event, Emitter<EditMemberState> emit) async {
    emit(state.copyWith(status: EditMemberStatus.loading));
    final newMeeting = _meeting
        .copyWith(members: [..._meeting.members, Member(name: state.name)]);
    try {
      await _meetingsRepository.saveMeeting(newMeeting);
      emit(state.copyWith(status: EditMemberStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditMemberStatus.failure));
    }
  }
}
