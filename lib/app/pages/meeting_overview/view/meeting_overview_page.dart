import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joint_purchases/app/pages/meeting_info/view/meeting_info_page.dart';
import 'package:joint_purchases/app/pages/meeting_overview/meeting_overview.dart';
import 'package:meetings_repository/meetings_repository.dart';

class MeetingOverviewPage extends StatelessWidget {
  const MeetingOverviewPage({super.key});

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
  const MeetingsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_rounded),
        title: const Text('Скинемся'),
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
                    const SnackBar(
                      content: Text('Ошибка загрузки данных'),
                    ),
                  );
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
                        Text('Удалена встреча ${deletedMeeting?.name ?? ''}'),
                    action: SnackBarAction(
                      label: 'Отменить',
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
                  child: Text('Что-то пошло не так :('),
                );
              } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Встреч пока не добавлено. Нажмите на +, чтобы добавить '
                      'первую встречу.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            }
            return const _MeetingsCards();
          },
        ),
      ),
    );
  }
}

class _MeetingsCards extends StatelessWidget {
  const _MeetingsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingsOverviewBloc, MeetingsOverviewState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final currDate = DateTime.now();

        return SafeArea(
          child: ColoredBox(
            color: theme.colorScheme.background,
            child: ListView(
              children: [
                for (final meeting in state.meetings)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Slidable(
                      key: ValueKey(meeting.hashCode),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        dismissible: DismissiblePane(
                          onDismissed: () => {
                            context
                                .read<MeetingsOverviewBloc>()
                                .add(MeetingsOverviewMeetingDeleted(meeting))
                          },
                        ),
                        children: [
                          SlidableAction(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            icon: Icons.delete_outline_rounded,
                            label: 'Удалить',
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: (BuildContext context) {
                              context
                                  .read<MeetingsOverviewBloc>()
                                  .add(MeetingsOverviewMeetingDeleted(meeting));
                            },
                          )
                        ],
                      ),
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 1,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MeetingInfoPage(meeting: meeting),
                              ),
                            );
                          },
                          title: Text(meeting.name),
                          subtitle: Text(meeting.date),
                          leading:
                              currDate.isAfter(DateTime.parse(meeting.date))
                                  ? const Icon(
                                      Icons.done_rounded,
                                      size: 40,
                                    )
                                  : const Icon(
                                      Icons.hourglass_empty_outlined,
                                      size: 40,
                                    ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
