import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../../edit_meeting/edit_meeting.dart';
import '../meeting_overview.dart';

class MeetingOverviewPage extends StatelessWidget {
  const MeetingOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingsOverviewBloc(
        meetingsRepository: context.read<MeetingsRepository>(),
      )..add(const MeetingsOverviewSubscriptionRequested()),
      child: const MeetingsOverviewView(),
    );
  }
}

class MeetingsOverviewView extends StatelessWidget {
  const MeetingsOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shopping_cart_rounded),
        title: const Text("Скинемся"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MeetingsOverviewBloc, MeetingsOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == MeetingsOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(content: Text("Ошибка загрузки данных")));
              }
            },
          ), //Show SnackBar, MeetingsOverviewStatus.failure

          BlocListener<MeetingsOverviewBloc, MeetingsOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedMeeting != current.lastDeletedMeeting &&
                current.lastDeletedMeeting != null,
            listener: (context, state) {
              final deletedMeeting = state.lastDeletedMeeting;
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              scaffoldMessenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text("Удалена встреча " + (deletedMeeting?.name ?? "")),
                    action: SnackBarAction(
                      label: "Отменить",
                      onPressed: () {
                        scaffoldMessenger.hideCurrentSnackBar();
                        context
                            .read<MeetingsOverviewBloc>()
                            .add(const MeetingsOverviewUndoDeletingRequested());
                      },
                    ),
                  ),
                );
            },
          ) //Show SnackBar, meeting deleted
        ],
        child: BlocBuilder<MeetingsOverviewBloc, MeetingsOverviewState>(
          builder: (context, state) {
            if (state.meetings.isEmpty) {
              if (state.status == MeetingsOverviewStatus.loading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state.status != MeetingsOverviewStatus.success) {
                return const Center(
                  child: Text("Что-то пошло не так :("),
                );
              } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Встреч пока не добавлено. Нажмите на +, чтобы добавить первую встречу.",
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            }
            return CupertinoScrollbar(
                child: ListView(
              children: [
                for (final meeting in state.meetings)
                  MeetingListTitle(
                      meeting: meeting,
                      onDismissed: (_) {
                        context
                            .read<MeetingsOverviewBloc>()
                            .add(MeetingsOverviewMeetingDeleted(meeting));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                            EditMeetingPage.route(initialMeeting: meeting));
                      })
              ],
            ));
          },
        ),
      ),
    );
  }
}
