
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rbna2/repository/convertRepository.dart';
import 'package:flutter_rbna2/repository/currencyRepository.dart';
import 'package:flutter_rbna2/repository/historyRepository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  ConvertRepository,
  CurrencyRepository,
  HistoryRepository
],
customMocks: [MockSpec<Dio>(as: #MockDioClient)]
)
void main(){

}