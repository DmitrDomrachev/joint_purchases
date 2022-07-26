import 'package:meetings_api/meetings_api.dart';

/// {@template meetings_api}
/// The interface and models for an API providing access to meetings.
/// {@endtemplate}
abstract class MeetingsApi {
  /// {@macro meetings_api}
  const MeetingsApi();

  /// Provides a [Stream] of all [Meeting]s.
  Stream<List<Meeting>> getMeetings();

  /// Saves a [Meeting].
  ///
  /// If a [Meeting] with the same id already exists, it will be replaced.
  Future<void> saveMeeting(Meeting meeting);

  /// Deletes the meeting_info with the given id.
  ///
  /// If no meeting_info with the given id exists, a [MeetingNotFoundException] error is
  /// thrown.
  Future<void> deleteMeeting(String id);
}

class MeetingNotFoundException implements Exception {}
