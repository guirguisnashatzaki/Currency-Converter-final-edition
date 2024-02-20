import 'package:flutter/material.dart';

import '../db_handler/db_handler.dart';
import '../models/conversionHistory.dart';
import '../web_services/currency_web_service.dart';

class HistoryPage extends StatefulWidget {
  DBHelper db;
  CurrencyWebService currencyWebService;
  HistoryPage({Key? key,required this.db,required this.currencyWebService}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  List<ConversionHistory> data = [
    ConversionHistory(
      toCurrencyName: "Pakistan Rupee",
      fromCurrencyName: "Bitcoin",
      toCode: "PKR",
      fromCode: "BTC",
      convertedAmount: 500,
      amount: 200,
      date: "2024-02-19"
    ),
    ConversionHistory(
        toCurrencyName: "Pakistan Rupee",
        fromCurrencyName: "Bitcoin",
        toCode: "PKR",
        fromCode: "BTC",
        convertedAmount: 500,
        amount: 200,
        date: "2024-02-19"
    ),
    ConversionHistory(
        toCurrencyName: "Pakistan Rupee",
        fromCurrencyName: "Bitcoin",
        toCode: "PKR",
        fromCode: "BTC",
        convertedAmount: 500,
        amount: 200,
        date: "2024-02-19"
    ),
    ConversionHistory(
        toCurrencyName: "Pakistan Rupee",
        fromCurrencyName: "Bitcoin",
        toCode: "PKR",
        fromCode: "BTC",
        convertedAmount: 500,
        amount: 200,
        date: "2024-02-19"
    ),
    ConversionHistory(
        toCurrencyName: "Pakistan Rupee",
        fromCurrencyName: "Bitcoin",
        toCode: "PKR",
        fromCode: "BTC",
        convertedAmount: 500,
        amount: 200,
        date: "2024-02-19"
    ),
    ConversionHistory(
        toCurrencyName: "Pakistan Rupee",
        fromCurrencyName: "Bitcoin",
        toCode: "PKR",
        fromCode: "BTC",
        convertedAmount: 500,
        amount: 200,
        date: "2024-02-19"
    ),
    ConversionHistory(
        toCurrencyName: "Pakistan Rupee",
        fromCurrencyName: "Bitcoin",
        toCode: "PKR",
        fromCode: "BTC",
        convertedAmount: 500,
        amount: 200,
        date: "2024-02-11"
    )
  ];

  List<ConversionHistory> dataShown = [

  ];

  showData(){
    DateTime now = DateTime.now();
    DateTime temp;
    for (var element in data) {
      temp = DateTime(
          int.parse(element.date!.split("-")[0]),
          int.parse(element.date!.split("-")[1]),
          int.parse(element.date!.split("-")[2]),
      );

      Duration duration = now.difference(temp);
      
      if(duration.inDays <= 7){
        dataShown.add(element);
      }
    }
  }

  @override
  void didChangeDependencies() {
    showData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Currency Convertor",
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(7,36,249,1),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(7,36,249,1),
              Colors.white,
            ],
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.center,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(dataShown.length, (index){
                return Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  height: MediaQuery.of(context).size.height/7,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.black,
                        width: 2
                      )
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("From : ${dataShown[index].fromCode}"),
                          const SizedBox(width: 20,),
                          Text("To : ${dataShown[index].toCode}"),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Text("Amount converted : ${dataShown[index].amount.toString()}"),
                          const SizedBox(width: 20,),
                          Text("to : ${dataShown[index].convertedAmount.toString()}"),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.centerLeft,
                          child: Text("Date : ${dataShown[index].date}")
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}