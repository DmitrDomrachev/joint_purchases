import 'package:meetings_api/meetings_api.dart';
import 'package:test/test.dart';

void main() {
  group('member', () {
    Member createSubject({
      String? id = '1',
      String name = 'name',
      double balance = 1,
    }) {
      return Member(
        id: id,
        name: name,
        balance: balance,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      test('throws AssertionError when id is empty', () {
        expect(
          () => createSubject(id: ''),
          throwsA(isA<AssertionError>()),
        );
      });

      test('sets id if not provided', () {
        expect(
          createSubject(id: null).id,
          isNotEmpty,
        );
      });

      test('throws AssertionError when id is empty', () {
        expect(
          () => createSubject(id: ''),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          '1', //id
          'name', //name
          1, //balance
        ]),
      );
    });

    group('copy with', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(id: null, name: null, balance: null),
          equals(createSubject()),
        );
      });

      test('replaces every not null parameter', () {
        expect(
          createSubject().copyWith(id: '2', name: 'new name', balance: 2),
          equals(
            createSubject().copyWith(id: '2', name: 'new name', balance: 2),
          ),
        );
      });
    });

    group('json', () {
      test('to json', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{'id': '1', 'name': 'name', 'balance': 1}),
        );
      });

      test('from json', () {
        expect(
          Member.fromJson(
            const <String, dynamic>{'id': '1', 'name': 'name', 'balance': 1.0},
          ),
          equals(createSubject()),
        );
      });
    });
  });

  group('product', () {
    Product createSubject({
      String? id = '1',
      String name = 'name',
      double price = 1,
      List<String> membersId = const ['1'],
      String buyerId = '1',
    }) {
      return Product(
          id: id,
          name: name,
          price: price,
          membersId: membersId,
          buyerId: buyerId);
    }

    group('constructor', () {
      test('work correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('throws AssertionError when id is empty', () {
        expect(
          () => createSubject(id: ''),
          throwsA(isA<AssertionError>()),
        );
      });

      test('sets id if not provided', () {
        expect(
          createSubject(id: null).id,
          isNotEmpty,
        );
      });

      test('supports value equality', () {
        expect(
          createSubject(),
          equals(createSubject()),
        );
      });

      test('props are correct', () {
        expect(
          createSubject().props,
          equals([
            '1', //id
            'name', //name
            1, //price
            ['1'], //membersId
            '1'
          ]),
        );
      });

      group('copy with', () {
        test('returns the same object if not arguments are provided', () {
          expect(
            createSubject().copyWith(),
            equals(createSubject()),
          );
        });

        test('retains the old value for every parameter if null is provided',
            () {
          expect(
            createSubject().copyWith(
              id: null,
              name: null,
              price: null,
              membersId: null,
            ),
            equals(createSubject()),
          );
        });

        test('replace every not null parameter', () {
          expect(
            createSubject().copyWith(
              id: '2',
              name: 'new name',
              price: 2,
              membersId: const ['1', '2'],
            ),
            equals(
              createSubject(
                id: '2',
                name: 'new name',
                price: 2,
                membersId: const ['1', '2'],
              ),
            ),
          );
        });
      });

      group('json', () {
        test('from json', () {
          expect(
            createSubject(),
            equals(
              Product.fromJson(const <String, dynamic>{
                'id': '1',
                'name': 'name',
                'price': 1.0,
                'membersId': ['1'],
                'buyerId': '1',
              }),
            ),
          );
        });

        test('to json', () {
          expect(const <String, dynamic>{
            'id': '1',
            'name': 'name',
            'price': 1.0,
            'membersId': ['1'],
            'buyerId': '1',
          }, createSubject().toJson(),);
        });
      });
    });
  });

  group('meetings', () {
    final memberSubject = Member(id: '1', name: 'name', balance: 1);

    final productSubject =
        Product(id: '1', name: 'name', price: 1, membersId: const ['1'], buyerId: '1');

    Meeting createSubject({
      String? id = '1',
      String name = 'name',
      String date = 'date',
      List<Member> members = const [],
      List<Product> products = const [],
    }) {
      return Meeting(
        id: id,
        name: name,
        date: date,
        members: members,
        products: products,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
      test('throws AssertionError when id is empty', () {
        expect(
          () => createSubject(id: ''),
          throwsA(isA<AssertionError>()),
        );
      });

      test('sets id if not provided', () {
        expect(
          createSubject(id: null).id,
          isNotEmpty,
        );
      });
    });
    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          '1', // id
          'name', // name
          'date', // date
          [], //members
          [], //products
        ]),
      );
    });

    group('copy with', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
              id: null, name: null, date: null, members: null, products: null),
          equals(createSubject()),
        );
      });

      test('replace every not null parameter', () {
        expect(
          createSubject().copyWith(
            id: '2',
            name: 'new name',
            date: 'new date',
            members: [memberSubject],
            products: [productSubject],
          ),
          equals(
            createSubject(
              id: '2',
              name: 'new name',
              date: 'new date',
              members: [memberSubject],
              products: [productSubject],
            ),
          ),
        );
      });
    });

    group('json', () {
      test('fromJson', () {
        expect(
          createSubject(members: [memberSubject], products: [productSubject]),
          equals(
            Meeting.fromJson(const <String, dynamic>{
              'id': '1',
              'name': 'name',
              'date': 'date',
              'members': [
                {'id': '1', 'name': 'name', 'balance': 1.0}
              ],
              'products': [
                {
                  'id': '1',
                  'name': 'name',
                  'price': 1.0,
                  'membersId': ['1'],
                  'buyerId':'1',
                }
              ]
            }),
          ),
        );
      });

      test('to json', () {
        expect(
          const <String, dynamic>{
            'id': '1',
            'name': 'name',
            'date': 'date',
            'members': [
              {'id': '1', 'name': 'name', 'balance': 1.0}
            ],
            'products': [
              {
                'id': '1',
                'name': 'name',
                'price': 1.0,
                'membersId': ['1'],
                'buyerId':'1',

              }
            ]
          },
          equals(
            createSubject(
              members: [memberSubject],
              products: [productSubject],
            ).toJson(),
          ),
        );
      });
    });
  });
}
