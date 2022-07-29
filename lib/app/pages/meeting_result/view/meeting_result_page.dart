import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:share_plus/share_plus.dart';
import '../meeting_result.dart';

class MeetingResultPage extends StatelessWidget {
  const MeetingResultPage({super.key, required this.meeting});

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingResultBloc(meeting: meeting)
        ..add(MeetingResultCalculateStarting()),
      child: MeetingResultView(),
    );
  }
}

class MeetingResultView extends StatelessWidget {
  const MeetingResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocBuilder<MeetingResultBloc, MeetingResultState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Итоги встречи'),
            actions: [
              IconButton(
                  onPressed: () {
                    Share.share(
                      state.meeting.members
                          .map((e) => e.resultCalculate())
                          .join('\n'),
                    );
                  },
                  icon: const Icon(Icons.share_outlined))
            ],
          ),
          body: SafeArea(
            child: ColoredBox(
              color: theme.colorScheme.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.meeting.name,
                          style: textTheme.headlineSmall,
                        ),
                        Text(
                          state.meeting.date,
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    //Members card
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Участники',
                                style: textTheme.bodyText2,
                              ),
                              Text('Долг'),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                        MembersListView(
                          members: state.meeting.members,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MembersListView extends StatelessWidget {
  const MembersListView({super.key, required this.members});

  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingResultBloc, MeetingResultState>(
      builder: (context, state) {
        return Container(
          child: members.isEmpty
              ? const ListTile(
                  title: Text('Участников нет'),
                )
              : Column(
                  children: [
                    for (final member in members)
                      ListTile(
                        title: Text(member.name),
                        trailing: Text(member.balance.toString()),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
