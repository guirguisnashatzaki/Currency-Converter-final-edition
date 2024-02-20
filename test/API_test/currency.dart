import 'package:dio/dio.dart';
import 'package:flutter_rbna2/constants.dart';
import 'package:flutter_rbna2/web_services/currency_web_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/test_helper.mocks.dart';

void main(){
  late MockDioClient mockDioClient;

  CurrencyWebService currencyWebService;

  Response successful = Response(requestOptions: RequestOptions(),statusCode: 200,data: []);
  Response unsuccessful = Response(requestOptions: RequestOptions(),statusCode: 404,data: []);
  String fromCode = "USD";
  String toCode = "EGP";

  setUp((){
    mockDioClient = MockDioClient();
    currencyWebService = CurrencyWebService.test(mockDioClient);
  });

  group(
      "get supported currencies",
          () {
        test("API call with 200", () async {
          currencyWebService = CurrencyWebService.test(mockDioClient);
          when(
              mockDioClient.get("v2.0/supported-currencies")
          ).thenAnswer(
              (_)async => successful
          );

          final result = await currencyWebService.getAllSupportedCurrencies();

          expect(result, isA<List>());

        });

        test("API call with 404", () async {
          currencyWebService = CurrencyWebService.test(mockDioClient);
          when(
              mockDioClient.get("v2.0/supported-currencies")
          ).thenAnswer(
                  (_)async => unsuccessful
          );

          final result = await currencyWebService.getAllSupportedCurrencies();

          expect(result, unsuccessful.data);

        });
    }
  );

  group(
      "convert API",
          () {
        test("API call with 200", () async {
          currencyWebService = CurrencyWebService.test(mockDioClient);
          when(
              mockDioClient.get("v2.0/rates/latest?apikey=$API_KEY&symbols=$fromCode,$toCode")
          ).thenAnswer(
                  (_)async => successful
          );

          final result = await currencyWebService.convert(fromCode, toCode, 10, "fromName", "toName");

          expect(result, null);

        });

        test("API call with 404", () async {
          currencyWebService = CurrencyWebService.test(mockDioClient);
          when(
              mockDioClient.get("v2.0/rates/latest?apikey=$API_KEY&symbols=$fromCode,$toCode")
          ).thenAnswer(
                  (_)async => unsuccessful
          );

          final result = await currencyWebService.convert(fromCode, toCode, 10, "fromName", "toName");

          expect(result, null);

        });
      }
  );
}