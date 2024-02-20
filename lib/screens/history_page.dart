import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rbna2/bussiness_logic/history/conversion_cubit.dart';

import '../constants.dart';
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

  List<ConversionHistory> data = [];

  List<ConversionHistory> dataShown = [

  ];

  String firstCurrency = "";
  String secondCurrency = "";
  bool filter = false;


  showData(bool filter){
    dataShown.clear();
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
        if(filter){
          if(firstCurrency == element.fromCode && secondCurrency == element.toCode){
            dataShown.add(element);
          }
        }else{
          dataShown.add(element);
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<ConversionCubit>(context).getAllConversionsDB();
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
      body: BlocBuilder<ConversionCubit,ConversionState>(
        builder: (BuildContext context, ConversionState state) {
          if(state is ConversionLoaded){
            data = (state).conversions;
            showData(filter);
            if(dataShown.isEmpty){
              return const Center(
                child: Text("There is nothing in history"),
              );
            }
            return Container(
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
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      var res = await Navigator.pushNamed(context, choose);
                      if(res != null && res.toString().isNotEmpty){
                        setState(() {
                          firstCurrency = res.toString().split(",")[0];
                          secondCurrency = res.toString().split(",")[1];
                          filter = true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("Filter by : "),
                              const SizedBox(height: 15,),
                              Text("$firstCurrency,"),
                              Text(secondCurrency)
                            ],
                          ),
                          InkWell(onTap: (){
                            setState(() {
                              firstCurrency = "";
                              secondCurrency = "";
                              filter = false;
                            });
                          }, child: const Icon(Icons.clear),)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height/1.5,
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
                                    Expanded(
                                      child: Text("Amount converted : ${dataShown[index].amount.toString()}",maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                    ),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: Text("to : ${dataShown[index].convertedAmount.toString()}",maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                    ),
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
                ],
              ),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}