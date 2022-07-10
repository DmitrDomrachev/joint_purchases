import 'dart:async';
import 'dart:convert';

import 'package:meetings_api/meetings_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_meetings_api}
/// A Flutter implementation of the [MeetingsApi] that uses local storage.
/// {@endtemplate}
class LocalStorageMeetingsApi extends MeetingsApi {
  /// {@macro local_storage_meetings_api}
  LocalStorageMeetingsApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _meetingStreamController =
      BehaviorSubject<List<Meeting>>.seeded(const []);

  /// The key used for storing the meetings locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kMeetingsCollectionKey = '__meetings_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final meetingsJson = _getValue(kMeetingsCollectionKey);
    if (meetingsJson != null) {
      final meetings =
          List<Map<String, dynamic>>.from(jsonDecode(meetingsJson) as List)
              .map((e) => Meeting.fromJson(JsonMap.from(e)))
              .toList();
      _meetingStreamController.add(meetings);
    } else {
      _meetingStreamController.add(const []);
    }
  }

  @override
  Stream<List<Meeting>> getMeetings() =>
      _meetingStreamController.asBroadcastStream();

  @override
  Future<void> saveMeeting(Meeting meeting) {
    print("saveMeeting");
    final meetings = [..._meetingStreamController.value];
    final meetingIndex =
        meetings.indexWhere((element) => element.id == meeting.id);
    if (meetingIndex >= 0) {
      meetings[meetingIndex] = meeting;
    } else {
      meetings.add(meeting);
    }
    _meetingStreamController.add(meetings);
    return _setValue(kMeetingsCollectionKey, json.encode(meetings));
  }

  @override
  Future<void> deleteMeeting(String id) {
    final meetings = [..._meetingStreamController.value];
    final meetingIndex = meetings.indexWhere((element) => element.id == id);
    if (meetingIndex == -1) {
      throw MeetingNotFoundException();
    } else {
      meetings.removeAt(meetingIndex);
      _meetingStreamController.add(meetings);
      return _setValue(kMeetingsCollectionKey, json.encode(meetings));
    }
  }
}
