import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

part 'edit_product_event.dart';

part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  EditProductBloc({
    required MeetingsRepository meetingsRepository,
    required Meeting meeting,
    String? buyerId,
  })  : _meetingsRepository = meetingsRepository,
        _meeting = meeting,
        super(
          EditProductState(
            members: meeting.members,
            buyerId: buyerId ?? meeting.members.first.id,
          ),
        ) {
    on<EditProductNameChanged>(_onNameChanged);
    on<EditProductPriceChanged>(_onPriceChanged);
    on<EditProductMembersChanged>(_onMembersIdChanged);
    on<EditProductBuyerChanged>(_onBuyerChanged);
    on<EditProductSubmitted>(_onSubmitted);
  }

  final MeetingsRepository _meetingsRepository;
  final Meeting _meeting;

  void _onNameChanged(
    EditProductNameChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onPriceChanged(
    EditProductPriceChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(state.copyWith(price: event.price));
  }

  void _onBuyerChanged(
    EditProductBuyerChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(state.copyWith(buyerId: event.buyerId));
  }

  void _onMembersIdChanged(
    EditProductMembersChanged event,
    Emitter<EditProductState> emit,
  ) {
    final idsList = List<String>.from(state.membersId);
    event.value ? idsList.add(event.memberId) : idsList.remove(event.memberId);
    emit(state.copyWith(membersId: idsList));
  }

  Future<void> _onSubmitted(
    EditProductSubmitted event,
    Emitter<EditProductState> emit,
  ) async {
    emit(state.copyWith(status: EditProductStatus.loading));
    final newMeeting = _meeting.copyWith(
      products: [
        ..._meeting.products,
        Product(
          name: state.name,
          price: state.price,
          membersId: state.membersId,
          buyerId: state.buyerId,
        )
      ],
    );
    try {
      await _meetingsRepository.saveMeeting(newMeeting);
      emit(state.copyWith(status: EditProductStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditProductStatus.failure));
    }
  }
}
