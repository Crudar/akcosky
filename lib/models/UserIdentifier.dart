class UserIdentifier{
  String id;
  String login;

//<editor-fold desc="Data Methods">

  UserIdentifier({
    required this.id,
    required this.login,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserIdentifier &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          login == other.login);

  @override
  int get hashCode => id.hashCode ^ login.hashCode;

  @override
  String toString() {
    return 'UserIdentifier{' + ' id: $id,' + ' login: $login,' + '}';
  }

  UserIdentifier copyWith({
    String? id,
    String? login,
  }) {
    return UserIdentifier(
      id: id ?? this.id,
      login: login ?? this.login,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'login': this.login,
    };
  }

  factory UserIdentifier.fromMap(Map<String, dynamic> map) {
    return UserIdentifier(
      id: map['id'] as String,
      login: map['login'] as String,
    );
  }

//</editor-fold>
}