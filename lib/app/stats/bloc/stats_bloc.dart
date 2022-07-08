import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'stats_event.dart';

part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required MeetingsRepository meetingsRepository,
  })  : _meetingsRepository = meetingsRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final MeetingsRepository _meetingsRepository;

  Future<void> _onSubscriptionRequested(
      StatsSubscriptionRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach<List<Meeting>>(
      _meetingsRepository.getMeetings(),
      onData: (meetings) => state.copyWith(
        status: StatsStatus.success,
        meetingsCount: meetings.length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
