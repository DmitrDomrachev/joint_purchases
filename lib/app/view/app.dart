// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetings_repository/meetings_repository.dart';

import '../pages/home/view/view.dart';
import '../theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.meetingsRepository});

  final MeetingsRepository meetingsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: meetingsRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: JointPurchasesTheme.light,
      darkTheme: JointPurchasesTheme.dark,
      home: HomePage(),
    );
  }
}

