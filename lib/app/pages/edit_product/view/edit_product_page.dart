import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joint_purchases/app/pages/edit_product/edit_product.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key, required this.meeting});

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductBloc(
        meetingsRepository: context.read<MeetingsRepository>(),
        meeting: meeting,
      ),
      child: BlocListener<EditProductBloc, EditProductState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditProductStatus.success,
        listener: (context, state) => Navigator.of(context).pop(),
        child: const EditProductView(),
      ),
    );
  }
}

class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый товар'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {context.read<EditProductBloc>().add(EditProductSubmitted())},
        child: const Icon(Icons.save_rounded),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('edit_product_page_name_tf'),
              decoration: const InputDecoration(labelText: 'Название'),
              onChanged: (value) {
                context
                    .read<EditProductBloc>()
                    .add(EditProductNameChanged(value));
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              key: const Key('edit_product_page_price_tf'),
              decoration: const InputDecoration(labelText: 'Стоимость'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                context
                    .read<EditProductBloc>()
                    .add(EditProductPriceChanged(double.parse(value)));
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const BuyerChoose(),
            const SizedBox(
              height: 16,
            ),
            const MemberChips(),
          ],
        ),
      ),
    );
  }
}

class MemberChips extends StatelessWidget {
  const MemberChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductBloc, EditProductState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final member in state.members)
              InputChip(
                selected: state.membersId.contains(member.id),
                onSelected: (bool value) {
                  context
                      .read<EditProductBloc>()
                      .add(EditProductMembersChanged(member.id, value));
                },
                label: Text(member.name),
              )
          ],
        );
      },
    );
  }
}

// class MembersChoose extends StatelessWidget {
//   const MembersChoose({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EditProductBloc, EditProductState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             for (final member in state.members)
//               CheckboxListTile(
//                 title: Text(member.name),
//                 value: state.membersId.contains(member.id),
//                 onChanged: (bool? value) {
//                   context.read<EditProductBloc>().add(
//                       EditProductMembersChanged(member.id, value ?? false));
//                 },
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

class BuyerChoose extends StatelessWidget {
  const BuyerChoose({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductBloc, EditProductState>(
      builder: (context, state) {
        return DropdownButtonFormField(
          key: const Key('edit_product_page_buyer_ff'),
          isExpanded: true,
          value: state.buyerId,
          decoration: const InputDecoration(labelText: 'Покупатель'),
          onChanged: (value) {
            context
                .read<EditProductBloc>()
                .add(EditProductBuyerChanged(value.toString()));
          },
          items: state.members.map((Member member) {
            return DropdownMenuItem(
              value: member.id,
              child: Text(member.name),
            );
          }).toList(),
        );
      },
    );
  }
}
