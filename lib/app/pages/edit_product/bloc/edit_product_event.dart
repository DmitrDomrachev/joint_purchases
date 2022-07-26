part of 'edit_product_bloc.dart';

class EditProductEvent extends Equatable {
  const EditProductEvent();

  @override
  List<Object?> get props => [];
}

class EditProductNameChanged extends EditProductEvent {
  EditProductNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class EditProductPriceChanged extends EditProductEvent {
  EditProductPriceChanged(this.price);

  final double price;

  @override
  List<Object?> get props => [price];
}

class EditProductBuyerChanged extends EditProductEvent {
  EditProductBuyerChanged(this.buyerId);

  final String buyerId;

  @override
  List<Object?> get props => [buyerId];
}

class EditProductMembersChanged extends EditProductEvent {
  EditProductMembersChanged(this.memberId, this.value);

  final String memberId;
  final bool value;

  @override
  List<Object?> get props => [memberId, value];
}

class EditProductSubmitted extends EditProductEvent {
  EditProductSubmitted();
}
