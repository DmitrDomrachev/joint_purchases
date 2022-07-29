import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meetings_api/meetings_api.dart';

part 'meeting_result_event.dart';

part 'meeting_result_state.dart';

class MeetingResultBloc extends Bloc<MeetingResultEvent, MeetingResultState> {
  MeetingResultBloc({required Meeting meeting})
      : _meeting = meeting,
        super(MeetingResultState(meeting: meeting)) {
    on<MeetingResultCalculateStarting>(_onCalculate);
  }

  Meeting _meeting;

  void _onCalculate(
      MeetingResultCalculateStarting event, Emitter<MeetingResultState> emit) {

    for (final product in _meeting.products) {
      final pricePerMember = product.price / product.membersId.length;

      var productMembers = _meeting.members
          .where((element) => product.membersId.contains(element.id))
          .toList(); //покупатели товара

      final otherMembers = _meeting.members
          .where((element) => !productMembers.contains(element))
          .toList(); //не покупатели

      productMembers = productMembers
          .map((e) => e.copyWith(balance: e.balance + pricePerMember))
          .toList(); //покупатели с новым балансом

      var resMembers = [...otherMembers, ...productMembers];

      final buyer =
          resMembers.firstWhere((element) => element.id == product.buyerId);

      resMembers
        ..removeWhere((element) => element.id == buyer.id)
        ..add(buyer.copyWith(balance: buyer.balance - product.price));

      _meeting = _meeting.copyWith(members: resMembers);
      print('meeting after calculating product ${product.name}: \n $_meeting');
    }
    emit(state.copyWith(meeting: _meeting));

  }
}
