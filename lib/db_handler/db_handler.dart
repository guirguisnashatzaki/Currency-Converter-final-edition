import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import '../models/conversionHistory.dart';
import '../models/supportedCurrencies.dart';

class DBHelper{

  static Database? _db;

  Future<Database?> get db async{
    if(_db!=null){
      return _db;
    }
    _db=await initDatabase();
    return _db;
  }

  initDatabase() async{
    io.Directory documentDirectory=await getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path,'CurrencyConverter.db');
    var db=await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute(
      "CREATE TABLE conversion_history (id INTEGER PRIMARY KEY AUTOINCREMENT,"
          " from_code TEXT NOT NULL,"
          " to_code TEXT NOT NULL,"
          " from_currency_name TEXT NOT NULL,"
          " to_currency_name TEXT NOT NULL,"
          " date TEXT NOT NULL,"
          " amount DOUBLE NOT NULL,"
          " convertedAmount DOUBLE NOT NULL)",
    );

    await db.execute(
      "CREATE TABLE supported_currency (id INTEGER PRIMARY KEY AUTOINCREMENT,"
          " code TEXT NOT NULL,"
          " currencyName TEXT NOT NULL,"
          " flag TEXT NOT NULL)",
    );
  }


  Future<ConversionHistory> insertConversion(ConversionHistory dbModel) async{

    var dbCurrency= await db;
    await dbCurrency!.insert('conversion_history', dbModel.toJson());

    return dbModel;
  }

  Future<SupportedCurrency> insertCurrency(SupportedCurrency dbModel) async{

    var dbCurrency= await db;
    await dbCurrency!.insert('supported_currency', dbModel.toJson());

    return dbModel;
  }


  Future<List<SupportedCurrency>> getCurrencies() async{

    var dbClient= await db;
    final List<Map<String,Object?>> queryResult=await dbClient!.query('supported_currency');

    return queryResult.map((e) => SupportedCurrency.fromJson(e)).toList();
  }

  Future<List<ConversionHistory>> getConversions() async{

    var dbClient= await db;
    final List<Map<String,Object?>> queryResult=await dbClient!.query('conversion_history');

    return queryResult.map((e) => ConversionHistory.fromJson(e)).toList();
  }

}