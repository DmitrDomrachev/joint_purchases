import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joint_purchases/app/pages/home/cubit/home_cubit.dart';
import 'package:joint_purchases/app/pages/new_meeting/new_meeting.dart';

import '../../meeting_overview/meeting_overview.dart';
import '../../stats/stats.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.homeTab);

    return Scaffold(
      body: IndexedStack(
          index: selectedTab.index,
          children: const [MeetingOverviewPage(), StatsPage()]),
      floatingActionButton: FloatingActionButton(
        key: const Key("homeView_addMeeting_floatingActionButton"),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewMeetingPage()));
        },
        child: const Icon(Icons.add_rounded),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       _HomeTabButton(
      //         groupValue: selectedTab,
      //         value: HomeTab.meetings,
      //         icon: const Icon(Icons.list_rounded),
      //       ),
      //       _HomeTabButton(
      //         groupValue: selectedTab,
      //         value: HomeTab.stats,
      //         icon: const Icon(Icons.show_chart_rounded),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
