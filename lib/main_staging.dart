// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:joint_purchases/bootstrap.dart';

import 'package:flutter/widgets.dart';
import 'package:local_storage_meetings_api/local_storage_meetings_api.dart';
import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final meetingsApi = LocalStorageMeetingsApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(meetingsApi: meetingsApi);
}
