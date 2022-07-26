import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../edit_member.dart';

class EditMemberPage extends StatelessWidget {
  const EditMemberPage({Key? key, required this.meeting}) : super(key: key);

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMemberBloc(
          meetingsRepository: context.read<MeetingsRepository>(),
          meeting: meeting),
      child: BlocListener<EditMemberBloc, EditMemberState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditMemberStatus.success,
        listener: (context, state) => Navigator.of(context).pop(),
        child: NewMemberView(),
      ),
    );
  }
}

class NewMemberView extends StatelessWidget {
  const NewMemberView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Новый участник'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            {context.read<EditMemberBloc>().add(EditMemberSubmitted())},
        backgroundColor: fabBackgroundColor,
        label: Text("Добавить"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Имя"),
            TextFormField(
              initialValue: '',
              maxLength: 50,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              onChanged: (value) {
                context.read<EditMemberBloc>().add(EditMemberNameChanged(value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
