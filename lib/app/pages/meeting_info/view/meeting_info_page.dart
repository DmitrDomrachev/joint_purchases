import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joint_purchases/app/pages/meeting_result/view/meeting_result_page.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../../edit_member/edit_member.dart';
import '../../edit_product/edit_product.dart';
import '../meeting_info.dart';

export '../bloc/meeting_info_bloc.dart';
export '../view/meeting_info_page.dart';

class MeetingInfoPage extends StatelessWidget {
  const MeetingInfoPage({super.key, required this.meeting});

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingInfoBloc(
          meeting: meeting,
          meetingsRepository: context.read<MeetingsRepository>())
        ..add(const MeetingInfoSubscriptionRequested()),
      child: const MeetingInfoView(),
    );
  }
}

class MeetingInfoView extends StatelessWidget {
  const MeetingInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
      builder: (context, state) {
        var theme = Theme.of(context);
        var textTheme = theme.textTheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Информация о встрече'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MeetingResultPage(
                    meeting: state.meeting,
                  ),
                ),
              );
            },
            child: const Icon(Icons.calculate_rounded),
          ),
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.background,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.meeting.name,
                            style: textTheme.headlineSmall,
                          ),
                          Text(
                            state.meeting.date,
                            style: textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ), //Head
                    const SizedBox(
                      height: 16,
                    ),
                    Card(
                      //Members card
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Участники',
                                  style: textTheme.bodyText2,
                                ),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditMemberPage(
                                                meeting: state.meeting,
                                              ),
                                            ),
                                          ),
                                        },
                                    child: Text('ДОБАВИТЬ')),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: theme.colorScheme.onSurface,
                          ),
                          MembersListView(
                            members: state.meeting.members,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Card(
                      //Members card
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Товары',
                                  style: textTheme.bodyText2,
                                ),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProductPage(
                                                meeting: state.meeting,
                                              ),
                                            ),
                                          ),
                                        },
                                    child: Text('ДОБАВИТЬ')),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: theme.colorScheme.onSurface,
                          ),
                          ProductsListView(products: state.meeting.products),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MembersListView extends StatelessWidget {
  const MembersListView({super.key, required this.members});

  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
      builder: (context, state) {
        return Container(
          child: members.isEmpty
              ? const ListTile(
                  title: Text('Участников пока нет'),
                )
              : Column(
                  children: [
                    for (final member in members)
                      ListTile(
                        title: Text(member.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () {
                            context
                                .read<MeetingInfoBloc>()
                                .add(MeetingInfoMemberDeleted(member));
                          },
                        ),
                      )
                  ],
                ),
        );
      },
    );
  }
}

class ProductsListView extends StatelessWidget {
  const ProductsListView({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
      builder: (context, state) {
        return Container(
          child: products.isEmpty
              ? const ListTile(
                  title: Text('Товаров пока нет'),
                )
              : Column(
                  children: [
                    for (final product in products)
                      ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            '${product.price} рублей, ${product.membersId.length} участников'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () {
                            context
                                .read<MeetingInfoBloc>()
                                .add(MeetingInfoProductDeleted(product));
                          },
                        ),
                      )
                  ],
                ),
        );
      },
    );
  }
}
