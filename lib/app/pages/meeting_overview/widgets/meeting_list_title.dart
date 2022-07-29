import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meetings_repository/meetings_repository.dart';

class MeetingListTitle extends StatelessWidget {
  const MeetingListTitle(
      {super.key, required this.meeting, required this.onDeleted, this.onTap});

  final Meeting meeting;
  final VoidCallback? onTap;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(onDismissed: onDeleted),
        children: [
          SlidableAction(
            icon: Icons.delete_outline_rounded,
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            onPressed: (BuildContext context) {},
          )
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: const ListTile(
          title: Text('Slide me'),
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   final nowDate = DateTime.now();
//   final meetingDate = DateTime.parse(meeting.date);
//   final theme = Theme.of(context);
//   return Dismissible(
//     onDismissed: onDismissed,
//     direction: DismissDirection.endToStart,
//     background: Container(
//       alignment: Alignment.centerRight,
//       color: theme.colorScheme.error,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Icon(Icons.delete_outline_rounded),
//     ),
//     key: Key("meeting_overview_list_${meeting.id}"),
//     child: ListTile(
//       onTap: onTap,
//       leading: nowDate.isAfter(meetingDate)
//           ? Icon(
//               Icons.done,
//               color: Colors.green,
//             )
//           : Icon(
//               Icons.calendar_month,
//             ),
//       title: Text(
//         meeting.name,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//       subtitle: Text(
//         meeting.date,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   );
// }
}
