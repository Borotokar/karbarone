import 'package:borotokar/AppDatabase.dart';
import 'package:borotokar/database/TokenDao.dart';
import 'package:get/get.dart'; // مسیر فایل دیتابیس شما

class DatabaseController extends GetxController {
  late AppDatabase database;
  late TokenDao tokendao;

  @override
  void onInit() {
    super.onInit();
    initDatabase();
    // sleep(Duration(seconds:3));
  }

  Future<void> initDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('AppDatabase.db').build();
    tokendao = database.tokenDao;
    // final token =_database.tokenDao.findTokenById(1);
    // Get.log("${token.token}");
  }

  Future<String?> checkToken() async {
    final token = await tokendao.getToken();
    return token;
  }
}
