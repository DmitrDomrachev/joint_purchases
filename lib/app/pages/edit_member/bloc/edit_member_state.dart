part of 'edit_member_bloc.dart';

enum EditMemberStatus { initial, loading, success, failure }

class EditMemberState extends Equatable {
  const EditMemberState({
    this.status = EditMemberStatus.initial,
    this.name = '',
  });

  final EditMemberStatus status;
  final String name;

  @override
  List<Object> get props => [status, name];

  EditMemberState copyWith({
    EditMemberStatus? status,
    String? name,
  }) {
    return EditMemberState(
      status: status ?? this.status,
      name: name ?? this.name,
    );
  }
}
