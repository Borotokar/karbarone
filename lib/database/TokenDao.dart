import 'package:borotokar/database/Token.dart';
import 'package:floor/floor.dart';

@dao
abstract class TokenDao {
  @Query('SELECT * FROM Token WHERE id = :id')
  Future<Token?> findTokenById(int id);

  @Query('SELECT token FROM Token WHERE id = 1 LIMIT 1')
  Future<String?> getToken();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertToken(Token token);

  @delete
  Future<void> deleteToken(Token token);
}
