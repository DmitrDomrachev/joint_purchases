part of 'home_cubit.dart';

enum HomeTab { meetings, stats }

class HomeState extends Equatable {
  const HomeState({this.homeTab = HomeTab.meetings});

  final HomeTab homeTab;

  @override
  List<Object?> get props => [homeTab];
}