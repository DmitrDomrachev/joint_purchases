import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../edit_product.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({Key? key, required this.meeting}) : super(key: key);

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductBloc(
          meetingsRepository: context.read<MeetingsRepository>(),
          meeting: meeting),
      child: BlocListener<EditProductBloc, EditProductState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditProductStatus.success,
        listener: (context, state) => Navigator.of(context).pop(),
        child: EditProductView(),
      ),
    );
  }
}

class EditProductView extends StatelessWidget {
  const EditProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text("Новый товар"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            {context.read<EditProductBloc>().add(EditProductSubmitted())},
        backgroundColor: fabBackgroundColor,
        label: Text("Сохранить"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Название"),
            TextFormField(
              initialValue: '',
              maxLength: 50,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              onChanged: (value) {
                context
                    .read<EditProductBloc>()
                    .add(EditProductNameChanged(value));
              },
            ),
            Text("Стоимость"),
            TextFormField(
              initialValue: '',
              maxLength: 10,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                context
                    .read<EditProductBloc>()
                    .add(EditProductPriceChanged(double.parse(value)));
              },
            ),
            Text("Приобрел товар"),
            BuyerChoose(),
            Text("Изпользовали товар"),
            MembersChoose(),
          ],
        ),
      ),
    );
  }
}

class MembersChoose extends StatelessWidget {
  const MembersChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductBloc, EditProductState>(
      builder: (context, state) {
        return Column(
          children: [
            for (final member in state.members)
              CheckboxListTile(
                title: Text(member.name),
                value: state.membersId.contains(member.id),
                onChanged: (bool? value) {
                  context.read<EditProductBloc>().add(
                      EditProductMembersChanged(member.id, value ?? false));
                },
              ),
          ],
        );
      },
    );
  }
}

class BuyerChoose extends StatelessWidget {
  const BuyerChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductBloc, EditProductState>(
      builder: (context, state) {
        return Container(
          child: DropdownButton(
            value: state.buyerId,
            onChanged: (value) {
              context
                  .read<EditProductBloc>()
                  .add(EditProductBuyerChanged(value.toString()));
            },
            items: state.members.map((Member member) {
              return DropdownMenuItem(
                child: Text(member.name),
                value: member.id,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
