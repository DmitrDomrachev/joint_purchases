import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../edit_member.dart';

class EditMemberPage extends StatelessWidget {
  const EditMemberPage({super.key, required this.meeting});

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
        child: const NewMemberView(),
      ),
    );
  }
}

class NewMemberView extends StatelessWidget {
  const NewMemberView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Участник'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {context.read<EditMemberBloc>().add(const EditMemberSubmitted())},
        child: const Icon(Icons.save_rounded),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: const InputDecoration(labelText: 'Имя'),
          onChanged: (value) {
            context.read<EditMemberBloc>().add(EditMemberNameChanged(value));
          },
        ),
      ),
    );
  }
}
