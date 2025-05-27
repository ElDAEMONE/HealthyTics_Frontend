class LoggedUser {
  static final  int admin = 1;
  static final int user = 2;

  final String? uid, name, email;
  final int type;

  LoggedUser({this.uid, this.name, this.email, required this.type});
}
