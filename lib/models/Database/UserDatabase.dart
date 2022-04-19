import '../Group.dart';

class UserDatabase{
  final String id;
  final String login;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final List<String> groupIDs;
  Map<String, Group> groups = {};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDatabase &&
          runtimeType == other.runtimeType &&
          passwordHash == other.passwordHash;

  @override
  int get hashCode => passwordHash.hashCode;

  UserDatabase(this.id, this.login, this.email, this.passwordHash, this.passwordSalt, this.groupIDs);
}
