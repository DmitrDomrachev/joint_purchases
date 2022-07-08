// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meetings_api/meetings_api.dart';
import 'package:meetings_repository/meetings_repository.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';

void bootstrap({required MeetingsApi meetingsApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final meetingsRepository = MeetingsRepository(meetingsApi: meetingsApi);

  runZonedGuarded(
        () async {
      await BlocOverrides.runZoned(
            () async => runApp(
          App(meetingsRepository: meetingsRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
        (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}