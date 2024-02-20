import 'package:flutter_rbna2/db_handler/db_handler.dart';
import 'package:flutter_rbna2/models/supportedCurrencies.dart';
import 'package:flutter_rbna2/web_services/currency_web_service.dart';

class CurrencyRepository{

  final CurrencyWebService currencyWebService;
  final DBHelper db;

  const CurrencyRepository({
    required this.currencyWebService,
    required this.db,
  });

  Future<List<SupportedCurrency>> getAllSupportedCurrencies() async{
    final currencies = await currencyWebService.getAllSupportedCurrencies();
    return currencies;
  }

  Future<SupportedCurrency> insertCurrency(SupportedCurrency currency) async{
    final insertedCurrency = await db.insertCurrency(currency);
    return insertedCurrency;
  }

  Future<List<SupportedCurrency>> getAllSupportedCurrenciesFromDB() async{
    final currencies = await db.getCurrencies();
    return currencies;
  }

}