import 'dart:io';
import '/models/module1/weather_model.dart';
import '/util/common/logger.dart';
import '/util/constants/locale_keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String DB_NAME_DEFAULT = DB_NAME_WEATHER;

const String DB_NAME_WEATHER = 'WEATHER_DB';
const String DB_NAME_PRODUCT = 'PRODUCT_DB';

const String TABLE_NAME = 'weatherTable';
const String PRIMARY_KEY = LocaleKeys.weather_key_woeid;
const String FIELD1 = LocaleKeys.weather_key_title;
const String FIELD2 = LocaleKeys.weather_key_min_temp;
const String FIELD3 = LocaleKeys.weather_key_max_temp;

class LocalDatabaseHelper {
  // static Database? _db;
  Database? _db;

  static LocalDatabaseHelper _productDatabaseHelper = LocalDatabaseHelper();

  static final LocalDatabaseHelper dbHelper =
      LocalDatabaseHelper._createInstance();

  LocalDatabaseHelper._createInstance();

  factory LocalDatabaseHelper() {
    if (_productDatabaseHelper == null) {
      _productDatabaseHelper = LocalDatabaseHelper._createInstance();
    }
    return _productDatabaseHelper;
  }

  Future<Database?> database({dbName = DB_NAME_DEFAULT}) async {
    // if (_db == null) {
    //   _db = await initializeDatabase(dbName);
    // }
    _db = await initializeDatabase(dbName);
    return _db;
  }

  Future<Database> initializeDatabase(dbName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;
    var myDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return myDatabase;
  }

  Future<void> delDatabase(dbName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;
    await deleteDatabase(path);
    // return myDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $TABLE_NAME"
        "($PRIMARY_KEY INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$FIELD1 TEXT, $FIELD2 INTEGER, $FIELD3 INTEGER )");
  }

  Future<void> insertWeather(WeatherModel weather,
      {dbName = DB_NAME_DEFAULT}) async {
    try {
      Database db = (await this.database(dbName: dbName))!;
      await db.execute(
          "INSERT INTO $TABLE_NAME ('$PRIMARY_KEY', '$FIELD1', '$FIELD2', '$FIELD3') values (?, ?, ?, ?)",
          [
            weather.locationId,
            weather.location,
            weather.minTemp,
            weather.maxTemp
          ]);
    } catch (e) {
      Logger.error("insert error");
    }
  }

  Future<Map<String, dynamic>?> getWeatherByID(int weatherId,
      {dbName = DB_NAME_DEFAULT}) async {
    try {
      Database db = (await this.database(dbName: dbName))!;
      List<Map<String, dynamic>> listResult = await db.rawQuery(
          "SELECT * FROM $TABLE_NAME WHERE $PRIMARY_KEY = ?", [weatherId]);
      Map<String, dynamic>? result = listResult[0];
      return result;
    } catch (e) {
      Logger.error(e.toString());
      return null;
    }
  }

  Future<Object?> getWeatherByLocation(String weatherLocation,
      {dbName = DB_NAME_DEFAULT}) async {
    try {
      Database db = (await this.database(dbName: dbName))!;
      String query =
          "SELECT * FROM $TABLE_NAME WHERE $FIELD1 LIKE '%$weatherLocation%'";
      List<Map<String, dynamic>>? listResult = await db.rawQuery(query);
      if (listResult.isEmpty) return null;
      Map<String, dynamic>? result = listResult[0];
      return result;
    } catch (e) {
      Logger.error(e.toString());
      return null;
    }
  }

  Future<void> updateWeather(WeatherModel weather,
      {dbName = DB_NAME_DEFAULT}) async {
    try {
      Database db = (await this.database(dbName: dbName))!;
      var query = "UPDATE $TABLE_NAME " +
          "SET $FIELD1 = ?, " +
          "$FIELD2 = ?, " +
          "$FIELD3 = ? " +
          "WHERE $PRIMARY_KEY = ? ";
      await db.execute(query, [
        weather.location,
        weather.minTemp,
        weather.maxTemp,
        weather.locationId,
      ]);
    } catch (e) {
      Logger.error("update error");
    }
  }

  Future<void> addWeather(WeatherModel weather,
      {dbName = DB_NAME_DEFAULT}) async {
    Object? dataLocal =
        await getWeatherByID(weather.locationId, dbName: dbName);
    if (dataLocal != null) {
      updateWeather(weather, dbName: dbName);
    } else {
      insertWeather(weather, dbName: dbName);
    }
  }

  close() async {
    var db = await this.database();
    var result = db!.close();
    return result;
  }
}
