import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../new_meeting.dart';

class NewMeetingPage extends StatelessWidget {
  const NewMeetingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewMeetingBloc(
        meetingsRepository: context.read<MeetingsRepository>(),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<NewMeetingBloc, NewMeetingState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status == NewMeetingStatus.success,
            listener: (context, state) => Navigator.of(context).pop(),
          ),
          BlocListener<NewMeetingBloc, NewMeetingState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == NewMeetingStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Произошла ошибка во время сохранения"),
                    ),
                  );
              }
            },
          ),
        ],
        child: NewMeetingView(),
      ),
    );
  }
}

class NewMeetingView extends StatelessWidget {
  const NewMeetingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return BlocBuilder<NewMeetingBloc, NewMeetingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Новая встреча'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: fabBackgroundColor,
            onPressed: () {
              if (state.name.isEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Название не может быть пустым"),
                    ),
                  );
              } else {
                context.read<NewMeetingBloc>().add(NewMeetingSubmitted());
              }
            },
            label: const Text("Создать"),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Название"),
                _NameField(),
                Text('Дата проведение'),
                _DatePicker(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime currentDate = DateTime.now();
    context
        .read<NewMeetingBloc>()
        .add(NewMeetingDateChanged(dateFormat.format(currentDate)));

    return BlocBuilder<NewMeetingBloc, NewMeetingState>(
      builder: (context, state) {


        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(state.date),
            TextButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));

                if (newDate != null) {
                  context
                      .read<NewMeetingBloc>()
                      .add(NewMeetingDateChanged(dateFormat.format(newDate)));
                }
              },
              child: Text("ИЗМЕНИТЬ"),
            )
          ],
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewMeetingBloc>().state;

    return TextFormField(
      // key: const Key('editMeetingView_name_textFormField'),

      initialValue: '',
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<NewMeetingBloc>().add(NewMeetingNameChanged(value));
      },
    );
  }
}
