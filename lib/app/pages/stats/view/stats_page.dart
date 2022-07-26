import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joint_purchases/app/pages/stats/stats.dart';
import 'package:meetings_repository/meetings_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        meetingsRepository: context.read<MeetingsRepository>(),
      )..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;

    return Center(
      child: Text("Кол-во встреч: " + state.meetingsCount.toString()),
    );
  }
}
