import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rbna2/constants.dart';
import 'package:flutter_rbna2/models/conversionHistory.dart';
import 'package:flutter_rbna2/models/supportedCurrencies.dart';

class CurrencyWebService{
  late Dio dio;

  //for testing only
  CurrencyWebService.test(this.dio);

  CurrencyWebService() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60)
    );

    dio = Dio(options);
  }

  List<SupportedCurrency> currencyMapper(Map mapEntry){
    List<SupportedCurrency> currencies = [];
    (mapEntry["supportedCurrenciesMap"] as Map).forEach((key, value) {
      if((value as Map)['countryCode'] != "Crypto"){
        currencies.add(SupportedCurrency(
          code: value['currencyCode'],
          currencyName: value['currencyName'],
          flag: value['icon']
        ));
      }
    });
    return currencies;
  }

  Future<List<SupportedCurrency>> getAllSupportedCurrencies() async {
    try{
      Response response = await dio.get("v2.0/supported-currencies");
      if (kDebugMode) {
        print(response.data.toString());
      }

      Map mapEntry = response.data as Map;
      return currencyMapper(mapEntry);
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  ConversionHistory prepareConversionHistory(Map mapEntry,String fromCode,String toCode,double amount,String fromName,String toName){
    double fromRate = double.parse(mapEntry['rates'][fromCode]);
    double toRate = double.parse(mapEntry['rates'][toCode]);
    String date = (mapEntry['date'] as String).split(" ")[0];
    double resRate = toRate / fromRate;
    double resAmount = amount * resRate;
    return ConversionHistory(
      date: date,
      amount: amount,
      convertedAmount: resAmount,
      fromCode: fromCode,
      toCode: toCode,
      fromCurrencyName: fromName,
      toCurrencyName: toName
    );
  }

  Future<ConversionHistory?> convert(String fromCode,String toCode,double amount,String fromName,String toName) async {
    try{
      Response response = await dio.get("v2.0/rates/latest?apikey=$API_KEY&symbols=$fromCode,$toCode");
      if (kDebugMode) {
        print(response.data.toString());
      }

      Map mapEntry = response.data as Map;
      return prepareConversionHistory(mapEntry, fromCode, toCode, amount, fromName, toName);
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}