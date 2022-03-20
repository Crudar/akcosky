import '../Group.dart';

class UserDomain{
  final String id;
  final String login;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final List<String> groupIDs;
  List<Group> groups = List.empty(growable: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDomain &&
          runtimeType == other.runtimeType &&
          passwordHash == other.passwordHash;

  @override
  int get hashCode => passwordHash.hashCode;

  UserDomain(this.id, this.login, this.email, this.passwordHash, this.passwordSalt, this.groupIDs);
}
