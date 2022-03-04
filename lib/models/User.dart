
class User{
  String id;
  String login;
  String passwordHash;
  String salt;
  String email;

  User(this.id, this.login, this.passwordHash, this.salt, this.email);
}
