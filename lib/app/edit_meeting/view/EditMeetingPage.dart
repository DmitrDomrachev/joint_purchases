import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joint_purchases/app/edit_meeting/bloc/edit_meeting_bloc.dart';
import 'package:meetings_repository/meetings_repository.dart';

class EditMeetingPage extends StatelessWidget {
  const EditMeetingPage({Key? key}) : super(key: key);

  static Route<void> route({Meeting? initialMeeting}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
              create: (context) => EditMeetingBloc(
                  meetingsRepository: context.read<MeetingsRepository>(),
                  initialMeeting: initialMeeting),
              child: const EditMeetingPage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditMeetingBloc, EditMeetingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditMeetingStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: EditMeetingView(),
    );
  }
}

class EditMeetingView extends StatelessWidget {
  const EditMeetingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditMeetingBloc bloc) => bloc.state.status);
    final isNewMeeting =
        context.select((EditMeetingBloc bloc) => bloc.state.isNewMeeting);

    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
        appBar: AppBar(
          title: isNewMeeting
              ? Text("Новая встреча")
              : Text("Редактировать встречу"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: status.isLoadingOrSuccess
              ? fabBackgroundColor.withOpacity(0.5)
              : fabBackgroundColor,
          onPressed: status.isLoadingOrSuccess
              ? null
              : () =>
                  {context.read<EditMeetingBloc>().add(EditMeetingSubmitted())},
          child: status.isLoadingOrSuccess
              ? const CupertinoActivityIndicator()
              : const Icon(Icons.check_rounded),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Название",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              _NameField(),
              SizedBox(
                height: 16,
              ),
              Text(
                "Дата встречи",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              _DateField()
            ],
          ),
        ));
  }
}

class _DateField extends StatelessWidget {
  const _DateField({Key? key}) : super(key: key);

  void _pickDateDialog(BuildContext context, DateTime initialDate) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditMeetingBloc, EditMeetingState>(
      builder: (context, state) {
        DateTime date;
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');;
        if (state.date == "") {
          date = DateTime.now();
          context
              .read<EditMeetingBloc>()
              .add(EditMeetingDateChanged(dateFormat.format(date)));

        } else {
          date = DateTime.parse(state.date);
        }

        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(date),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              TextButton(
                child: Text(
                  "ИЗМЕНИТЬ",
                ),
                onPressed: () => {
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2120),
                  ).then((pickedDate) => {
                        if (pickedDate != null)
                          {
                            context.read<EditMeetingBloc>().add(
                                EditMeetingDateChanged(
                                    dateFormat.format(pickedDate)))
                          }
                      })
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditMeetingBloc>().state;
    final hintText = state.initialMeeting?.name ?? '';

    return TextFormField(
      key: const Key('editMeetingView_name_textFormField'),
      initialValue: state.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<EditMeetingBloc>().add(EditMeetingNameChanged(value));
      },
    );
  }
}

// stle

// class _DatePicker extends StatefulWidget {
//   const _DatePicker({Key? key}) : super(key: key);
//
//   @override
//   State<_DatePicker> createState() => _DatePickerState();
// }
//
// class _DatePickerState extends State<_DatePicker> {
//
//   DateTime date = DateTime.now();
//
//   void _showDialog(Widget child) {
//     showCupertinoModalPopup<void>(
//         context: context,
//         builder: (BuildContext context) => Container(
//               height: 216,
//               padding: const EdgeInsets.only(top: 6.0),
//               margin: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               color: CupertinoColors.systemBackground.resolveFrom(context),
//               child: SafeArea(
//                 top: false,
//                 child: child,
//               ),
//             ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final DateFormat  dateFormat= DateFormat("yyyy-MM-dd");
//
//     final state = context.watch<EditMeetingBloc>().state;
//     DateTime initialDate = DateTime.parse(state.initialMeeting?.date ?? dateFormat.format(date));
//
//     return CupertinoButton(
//       onPressed: () => _showDialog(
//         CupertinoDatePicker(
//           initialDateTime: initialDate,
//           mode: CupertinoDatePickerMode.date,
//           use24hFormat: true,
//           // This is called when the user changes the date.
//           onDateTimeChanged: (DateTime newDate) {
//             setState(() => initialDate = newDate);
//             context.read<EditMeetingBloc>().add(EditMeetingDateChanged(dateFormat.format(initialDate)));
//
//           },
//
//         ),
//       ),
//       child: Text(
//         '${initialDate.month}-${initialDate.day}-${initialDate.year}',
//       ),
//     );
//   }
// }
