import '../db_handler/db_handler.dart';
import '../models/conversionHistory.dart';
import '../web_services/currency_web_service.dart';

class HistoryRepository{

  final CurrencyWebService currencyWebService;
  final DBHelper db;

  const HistoryRepository({
    required this.currencyWebService,
    required this.db,
  });

  Future<ConversionHistory> insertConversion(ConversionHistory conversionHistory) async {
    final conversion = await db.insertConversion(conversionHistory);
    return conversion;
  }

  Future<List<ConversionHistory>> getConversionsFromDB() async {
    final conversions = await db.getConversions();
    return conversions;
  }

}