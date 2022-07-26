import 'package:flutter/material.dart';
import 'package:meetings_repository/meetings_repository.dart';

class MeetingListTitle extends StatelessWidget {
  const MeetingListTitle(
      {Key? key, required this.meeting, this.onDismissed, this.onTap})
      : super(key: key);

  final Meeting meeting;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime nowDate = DateTime.now();

    final DateTime meetingDate = DateTime.parse(meeting.date);
    final theme = Theme.of(context);
    return Dismissible(
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.chevron_right),
      ),
      key: Key("meeting_overview_list_${meeting.id}"),
      child: ListTile(
        onTap: onTap,
        leading: nowDate.isAfter(meetingDate)
            ? Icon(Icons.done, color: Colors.green,)
            : Icon(Icons.calendar_month,),
        title: Text(
          meeting.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          meeting.date,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
