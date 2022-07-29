import 'package:flutter/material.dart';
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
                    const SnackBar(
                      content: Text('Произошла ошибка во время сохранения'),
                    ),
                  );
              }
            },
          ),
        ],
        child: const NewMeetingView(),
      ),
    );
  }
}

class NewMeetingView extends StatelessWidget {
  const NewMeetingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMeetingBloc, NewMeetingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Новая встреча'),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save_rounded),
            onPressed: () {
              context.read<NewMeetingBloc>().add(const NewMeetingSubmitted());
            },
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _NameField(),
                SizedBox(
                  height: 16,
                ),
                _DateField(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(labelText: 'Название'),
      onChanged: (value) {
        context.read<NewMeetingBloc>().add(NewMeetingNameChanged(value));
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    final dateFormat = DateFormat('yyyy-MM-dd');
    final currentDate = DateTime.now();
    context
        .read<NewMeetingBloc>()
        .add(NewMeetingDateChanged(dateFormat.format(currentDate)));

    return BlocBuilder<NewMeetingBloc, NewMeetingState>(
      builder: (context, state) {
        _controller.value = _controller.value.copyWith(text: state.date);
        return TextField(
          controller: _controller,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Дата проведения'),
          onTap: () async {
            final newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100));

            if (newDate == null) return;

            context.read<NewMeetingBloc>().add(
                  NewMeetingDateChanged(
                    dateFormat.format(newDate),
                  ),
                );
          },
        );
      },
    );
  }
}
