import '../db_handler/db_handler.dart';
import '../models/conversionHistory.dart';
import '../web_services/currency_web_service.dart';

class ConvertRepository{

  final CurrencyWebService currencyWebService;
  final DBHelper db;

  const ConvertRepository({
    required this.currencyWebService,
    required this.db,
  });

  Future<ConversionHistory?> convert(String fromCode,String toCode,double amount,String fromName,String toName) async {
    final conversion = await currencyWebService.convert(fromCode, toCode, amount, fromName, toName);
    return conversion;
  }

}