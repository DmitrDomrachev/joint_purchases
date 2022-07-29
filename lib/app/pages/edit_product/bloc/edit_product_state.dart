part of 'edit_product_bloc.dart';

enum EditProductStatus { initial, loading, success, failure }

class EditProductState extends Equatable {
  const EditProductState({
    this.status = EditProductStatus.initial,
    this.name = '',
    this.price = 0,
    required this.members,
    required this.buyerId,
    this.membersId = const [],
  });

  final EditProductStatus status;
  final String name;
  final double price;
  final List<Member> members;
  final List<String> membersId;
  final String buyerId;

  @override
  List<Object> get props => [status, name, price, members, buyerId, membersId];

  EditProductState copyWith({
    EditProductStatus? status,
    String? name,
    double? price,
    List<Member>? members,
    List<String>? membersId,
    String? buyerId,
  }) {
    return EditProductState(
      status: status ?? this.status,
      name: name ?? this.name,
      price: price ?? this.price,
      members: members ?? this.members,
      membersId: membersId ?? this.membersId,
      buyerId: buyerId ?? this.buyerId,
    );
  }
}
