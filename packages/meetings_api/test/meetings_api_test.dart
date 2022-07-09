import 'package:meetings_api/meetings_api.dart';
import 'package:test/test.dart';

class TestMeetingsApi extends MeetingsApi {
  TestMeetingsApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main(){
  group('MeetingsApi', () {
    test('can be constructed', () {
      expect(TestMeetingsApi.new, returnsNormally);
    });
  });
}