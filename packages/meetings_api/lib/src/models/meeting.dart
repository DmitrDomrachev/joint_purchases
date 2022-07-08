import 'package:equatable/equatable.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Meeting extends Equatable {
  Meeting({String? id, required this.name, required this.date})
      : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? Uuid().v4();

  ///The unique identifier of the meeting
  ///
  ///Cannot be empty
  final String id;

  ///The name of the meeting
  ///
  ///May be empty
  final String name;

  ///The date of the meeting
  ///
  ///May be empty
  final String date;

  ///Return the copy of this meeting with the given parameters
  Meeting copyWith({
    String? id,
    String? name,
    String? date,
  }) {
    return Meeting(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }

  ///Covert this [Meeting] into a [JsonMap]
  JsonMap toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'date': this.date,
    };
  }

  ///Deserializes the given [JsonMap] into a [Meeting]
  factory Meeting.fromJson(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] as String,
      name: map['name'] as String,
      date: map['date'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, date];
}
