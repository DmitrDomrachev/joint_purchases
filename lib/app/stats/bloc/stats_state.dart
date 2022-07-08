part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  const StatsState({this.status = StatsStatus.initial, this.meetingsCount = 0});

  final StatsStatus status;
  final int meetingsCount;

  @override
  List<Object?> get props => [status, meetingsCount];

  StatsState copyWith({
    StatsStatus? status,
    int? meetingsCount,
  }) {
    return StatsState(
      status: status ?? this.status,
      meetingsCount: meetingsCount ?? this.meetingsCount,
    );
  }
}
