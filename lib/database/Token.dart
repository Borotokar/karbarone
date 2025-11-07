import 'package:floor/floor.dart';

@Entity(tableName: 'Token')
class Token {
  @primaryKey
  final int id;
  final String token;

  get getToken => this.token;

  Token(this.id, this.token);
}
