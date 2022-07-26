part of 'edit_member_bloc.dart';

class EditMemberEvent extends Equatable {
  const EditMemberEvent();

  @override
  List<Object?> get props => [];
}

class EditMemberNameChanged extends EditMemberEvent {
  const EditMemberNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class EditMemberSubmitted extends EditMemberEvent {
  const EditMemberSubmitted();
}
