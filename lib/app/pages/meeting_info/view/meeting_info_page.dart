import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../../edit_member/edit_member.dart';
import '../../edit_product/edit_product.dart';
import '../meeting_info.dart';

export '../bloc/meeting_info_bloc.dart';
export '../view/meeting_info_page.dart';

class MeetingInfoPage extends StatelessWidget {
  const MeetingInfoPage({Key? key, required this.meeting}) : super(key: key);

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      MeetingInfoBloc(
          meeting: meeting,
          meetingsRepository: context.read<MeetingsRepository>())
        ..add(MeetingInfoSubscriptionRequested()),
      child: MeetingInfoView(),
    );
  }
}

class MeetingInfoView extends StatelessWidget {
  const MeetingInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
      builder: (context, state) {
        var textTheme = Theme
            .of(context)
            .textTheme;

        return Scaffold(
          appBar: AppBar(
            title: Text('Встреча'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.meeting.name,
                    style: textTheme.headline5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(state.meeting.date, style: textTheme.headline6),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Участники',
                        style: textTheme.bodyText2,
                      ),
                      TextButton(
                          onPressed: () =>
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditMemberPage(meeting: state.meeting),
                              ),
                            ),
                          },
                          child: Text('ДОБАВИТЬ')),
                    ],
                  ),
                  MembersListView(
                    members: state.meeting.members,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Товары',
                        style: textTheme.bodyText2,
                      ),
                      TextButton(
                          onPressed: () =>
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProductPage(meeting: state.meeting),
                              ),
                            ),
                          },
                          child: Text('ДОБАВИТЬ')),
                    ],
                  ),
                  ProductsListView(
                    products: state.meeting.products,
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
  const MembersListView({Key? key, required this.members}) : super(key: key);

  final List<Member> members;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
      builder: (context, state) {

        return Container(
          child: members.isEmpty
              ? Text("Пусто")
              : Column(
            children: [
              for (final member in members)
                MemberListTitle(
                  member: member,
                  onTapDel: () {
                    context
                        .read<MeetingInfoBloc>()
                        .add(MeetingInfoMemberDeleted(member));
                  },
                )
            ],
          ),
        );
      },
    );
  }
}

class ProductsListView extends StatelessWidget {
  const ProductsListView({Key? key, required this.products})
      : super(key: key);
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
      builder: (context, state) {
        return Container(
          child: products.isEmpty
              ? Text("Пусто")
              : Column(
            children: [
              for (final product in products)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Использовало ${product.membersId.length} человек"),
                        Text("${product.price} рублей"),
                        IconButton(
                            onPressed: () {
                              context.read<MeetingInfoBloc>().add(
                                  MeetingInfoProductDeleted(product));
                            }, icon: Icon(Icons.delete)),
                      ],
                    )
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
