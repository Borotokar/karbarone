import 'dart:async';
import 'package:borotokar/database/Token.dart';
import 'package:borotokar/database/TokenDao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart';

@Database(version: 1, entities: [Token])
abstract class AppDatabase extends FloorDatabase {
  TokenDao get tokenDao;
}
