part of 'groups_cubit.dart';

@immutable
abstract class GroupsState {
  const GroupsState();
}

class GroupsInitial extends GroupsState {
  const GroupsInitial();
  // TODO - GET USER GROUPS FROM USER REPOSITORY
}

class GroupsStatusMessage extends GroupsState{
  final String message;

  const GroupsStatusMessage(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupsStatusMessage &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;

  // TODO - ON STATUS SHOW REFRESH REPOSITORY
}
