import 'package:meetings_api/meetings_api.dart';

/// {@template meetings_repository}
/// A repository that handles meeting_info related requests.
/// {@endtemplate}
class MeetingsRepository {
  /// {@macro meetings_repository}
  MeetingsRepository({required MeetingsApi meetingsApi})
      : _meetingsApi = meetingsApi;

  final MeetingsApi _meetingsApi;

  /// Provides a [Stream] of all meetings.
  Stream<List<Meeting>> getMeetings() => _meetingsApi.getMeetings();


  /// Saves a [Meeting].
  ///
  /// If a [Meeting] with the same id already exists, it will be replaced with
  /// the minimal possible index;
  Future<void> saveMeeting(Meeting meeting) =>
      _meetingsApi.saveMeeting(meeting);

  /// Deletes the meeting_info with the given id.
  ///
  /// If no meeting_info with the given id exists, a [MeetingNotFoundException] error
  /// is thrown.
  Future<void> deleteMeeting(String id) => _meetingsApi.deleteMeeting(id);
}
