import 'package:equatable/equatable.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template meeting_info}
/// A single meeting_info item.
///
/// Contains a [name], [date], [members], [products] and [id]
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Meeting]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [Meeting.fromJson]
/// respectively.
/// {@endtemplate}
///
@immutable
class Meeting extends Equatable {
  /// {@macro meeting_info}
  Meeting({
    String? id,
    required this.name,
    required this.date,
    required this.members,
    required this.products,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  ///Deserializes the given [JsonMap] into a [Meeting]
  factory Meeting.fromJson(JsonMap map) {
    var membersList = <Member>[];
    var productsList = <Product>[];

    try {
      final membersJson =
          (map['members'] as List).map((dynamic e) => e as JsonMap).toList();
      membersList = membersJson.map(Member.fromJson).toList();
    } catch (e) {}

    try {
      final productsJson =
          (map['products'] as List).map((dynamic e) => e as JsonMap).toList();
      productsList = productsJson.map(Product.fromJson).toList();
    } catch (e) {}
    return Meeting(
      id: map['id'] as String,
      name: map['name'] as String,
      date: map['date'] as String,
      members: membersList,
      products: productsList,
    );
  }

  ///The unique identifier of the meeting_info
  ///
  ///Cannot be empty
  final String id;

  ///The name of the meeting_info
  ///
  ///May be empty
  final String name;

  ///The date of the meeting_info
  ///
  ///May be empty
  final String date;

  ///The list of the [Member]s
  ///
  ///May be empty
  final List<Member> members;

  ///The list of the [Product]s
  ///
  ///May be empty
  final List<Product> products;

  ///Covert this [Meeting] into a [JsonMap]
  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'members': members.map((e) => e.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  ///Return the copy of this meeting_info with the given parameters
  Meeting copyWith({
    String? id,
    String? name,
    String? date,
    List<Member>? members,
    List<Product>? products,
  }) {
    return Meeting(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      members: members ?? this.members,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [id, name, date, members, products];
}

/// {@template meeting_info}
/// A single member item.
///
/// Contains a [id] , [name] and [balance].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// /// If an [balance] is provided, it cannot be empty. If no [balance] is provided,
/// it will be equal to 0
///
/// [Member]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [Member.fromJson]
/// respectively.
/// {@endtemplate}
@immutable
class Member extends Equatable {
  /// {@macro Member}
  Member({String? id, required this.name, this.balance = 0})
      : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  ///Deserializes the given [JsonMap] into a [Member]
  factory Member.fromJson(JsonMap map) {
    return Member(
      id: map['id'] as String,
      name: map['name'] as String,
      balance: map['balance'] as double,
    );
  }

  ///The unique identifier of the member
  ///
  ///Cannot be empty
  final String id;

  ///The name of the member
  ///
  ///May be empty
  final String name;

  ///The balance of the member
  ///
  ///May be empty
  final double balance;

  ///Covert this [Member] into a [JsonMap]
  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  ///Return the copy of this member with the given parameters
  Member copyWith({
    String? id,
    String? name,
    double? balance,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object> get props => [id, name, balance];
}

/// {@template product}
/// A single product item.
///
/// Contains a [name], [price], [membersId] and [id]
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Product]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [Product.fromJson]
/// respectively.
/// {@endtemplate}
///
@immutable
class Product extends Equatable {
  ///@{macro product}
  Product({
    String? id,
    required this.name,
    required this.price,
    required this.membersId,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  ///Deserializes the given [JsonMap] into a [Product]
  factory Product.fromJson(JsonMap map) {
    final membersIdJson =
        (map['membersId'] as List).map((dynamic e) => e as String).toList();
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      membersId: membersIdJson,
    );
  }

  ///The unique identifier of the product
  ///
  ///Cannot be empty
  final String id;

  ///The name of the product
  ///
  ///May be empty
  final String name;

  ///The price of the product
  ///
  ///May be empty
  final double price;

  ///The ID list of members who have used the product
  ///
  ///May be empty
  final List<String> membersId;

  @override
  List<Object?> get props => [id, name, price, membersId];

  ///Return the copy of this product with the given parameters
  Product copyWith({
    String? id,
    String? name,
    double? price,
    List<String>? membersId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      membersId: membersId ?? this.membersId,
    );
  }

  ///Covert this [Product] into a [JsonMap]
  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'membersId': membersId,
    };
  }
}
