import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_meetings_api/local_storage_meetings_api.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageMeetingApi', () {
    late SharedPreferences plugin;

    final meetings = [
      Meeting(
        name: 'name1',
        date: 'date1',
        members: [
          Member(name: 'Dmitry'),
          Member(name: 'Zahaaar'),
        ],
        products: [
          Product(
            name: 'Milk',
            price: 1.3,
            membersId: const ['1'], buyerId: '1',
          ),
          Product(
            name: 'Water',
            price: 0.5,
            membersId: const ['2'], buyerId: '2',
          )
        ],
      ),
      Meeting(
        name: 'name1',
        date: 'date1',
        members: const [],
        products: [
          Product(
            name: 'Milk',
            price: 1.3,
            membersId: const ['1'], buyerId: '1',
          ),
          Product(
            name: 'Water',
            price: 0.5,
            membersId: const ['2'], buyerId: '2',
          )
        ],
      ),
      Meeting(
        name: 'name1',
        date: 'date1',
        members: [
          Member(name: 'Dmitry'),
          Member(name: 'Zahaaar'),
        ],
        products: const [],
      ),
    ];

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(json.encode(meetings));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    LocalStorageMeetingsApi createSubject() {
      return LocalStorageMeetingsApi(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
      group('initializes the meetings stream', () {
        test('with existing todos if present', () {
          final subject = createSubject();

          expect(subject.getMeetings(), emits(meetings));
          verify(
            () => plugin.getString(
              LocalStorageMeetingsApi.kMeetingsCollectionKey,
            ),
          ).called(1);
        });

        test('with empty list if no meetings present', () {
          when(() => plugin.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getMeetings(), emits(const <Meeting>[]));
          verify(
            () => plugin.getString(
              LocalStorageMeetingsApi.kMeetingsCollectionKey,
            ),
          ).called(1);
        });
      });
    });
    test('getMeetings returns stream of current list meetings', () {
      expect(
        createSubject().getMeetings(),
        emits(meetings),
      );
    });
    // group('saveMeetings', () {
    //   test('save new meetings', () {
    //     final newMeeting = Meeting(
    //         name: 'new name', date: 'new date', members: [], products: []);
    //
    //     final newMeetings = [...meetings, newMeeting];
    //
    //     final subject = createSubject();
    //
    //     expect(subject.saveMeeting(newMeeting), completes);
    //     expect(subject.getMeetings(), emits(newMeetings));
    //
    //     verify(
    //       () => plugin.setString(
    //         LocalStorageMeetingsApi.kMeetingsCollectionKey,
    //         jsonEncode(newMeetings),
    //       ),
    //     ).called(1);
    //   });
    //
    //   test('updates existing todos', () {
    //     final updateMeeting = Meeting(
    //       id: '1',
    //       name: 'new name 1',
    //       date: 'new date 1',
    //       members: [Member(name: 'name')],
    //       products: [Product(name: 'name', price: 1.1, membersId: ['11'])]
    //     );
    //     final newMeetings = [updateMeeting, ...meetings.sublist(1)];
    //
    //     final subject = createSubject();
    //
    //     expect(subject.saveMeeting(updateMeeting), completes);
    //     expect(subject.getMeetings(), emits(newMeetings));
    //
    //     // verify(
    //     //       () => plugin.setString(
    //     //     LocalStorageMeetingsApi.kMeetingsCollectionKey,
    //     //     json.encode(newMeetings),
    //     //   ),
    //     // ).called(1);
    //   });
    // });
  });
}
