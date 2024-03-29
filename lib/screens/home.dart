import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rbna2/bussiness_logic/convert/convert_cubit.dart';
import 'package:flutter_rbna2/bussiness_logic/currency/currency_cubit.dart';
import 'package:flutter_rbna2/bussiness_logic/history/conversion_cubit.dart';
import 'package:flutter_rbna2/constants.dart';
import 'package:flutter_rbna2/db_handler/db_handler.dart';
import 'package:flutter_rbna2/models/conversionHistory.dart';
import 'package:flutter_rbna2/web_services/currency_web_service.dart';

import '../models/supportedCurrencies.dart';

class Home extends StatefulWidget {
  DBHelper db;
  CurrencyWebService currencyWebService;
  Home({Key? key,required this.currencyWebService,required this.db}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<SupportedCurrency> toCurrency = [];
  List<SupportedCurrency> fromCurrency = [];
  TextEditingController amountController = TextEditingController();
  String fromText = "???";
  String toText = "???";
  String fromImage = "assets/img_1.png";
  String toImage = "assets/img_1.png";
  String fromName = "";
  String toName = "";
  ConversionHistory? convertedAmount;
  bool isLoading = false;

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
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 10,top: 20,bottom: 20),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 50,),
              const Divider(),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, history);
                },
                child: Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 10,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text("Conversion History",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context,ConnectivityResult connectivity,Widget child){
          final bool connected = connectivity != ConnectivityResult.none;

          if(connected){
            fromCurrency = BlocProvider.of<CurrencyCubit>(context).getAllCurrenciesDB();
            toCurrency = fromCurrency;
            return SingleChildScrollView(
              child: Container(
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
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Amount",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 20
                            ),
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                          style: const TextStyle(
                              fontSize: 20
                          ),
                          controller: amountController,
                        ),
                      ),
                    ),

                    Positioned(
                        top: 90,
                        left: 0,
                        right: 0,
                        child: BlocBuilder<ConvertCubit,ConvertState>(
                          builder: (BuildContext context, state) {
                            if(state is ConvertLoaded){
                              convertedAmount = (state).conversion;
                              BlocProvider.of<ConversionCubit>(context).addConversion(convertedAmount!);
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: convertedAmount?.convertedAmount.toString(),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20
                                    ),
                                    contentPadding: const EdgeInsets.only(left: 15),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 20
                                  ),
                                ),
                              );
                            }else{
                              return const SizedBox.shrink();
                            }
                          },
                        )
                    ),

                    Positioned(
                      top: 240,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2.7),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: const Text("Convert",style: TextStyle(color: Color.fromRGBO(7,36,249,1)),),
                          onPressed: (){

                            bool from = false;
                            bool to = false;
                            bool amount = false;

                            if(fromText == "???"){
                              from = true;
                            }

                            if(toText == "???"){
                              to = true;
                            }

                            if(amountController.text.toString().isEmpty){
                              amount = true;
                            }else{
                              if(amountController.text.toString().split(".").length > 2){
                                amount = true;
                              }
                            }

                            String fromError = "Choose a currency to convert from";
                            String toError = "Choose a currency to convert to";
                            String amountError = "Put a valid value";

                            if(!from && !to && !amount){
                              setState(() {
                                isLoading = true;
                              });
                              BlocProvider.of<ConvertCubit>(context).convert(fromText, toText, double.parse(amountController.text.toString()), fromName, toName);
                            }else{
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      height: MediaQuery.of(context).size.height/2,
                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        children: [
                                          from? Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white
                                              ),
                                              child: Text(fromError)
                                          ):const SizedBox.shrink(),
                                          const SizedBox(height: 5,),
                                          to?Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white
                                              ),
                                              child: Text(toError)
                                          ):const SizedBox.shrink(),
                                          const SizedBox(height: 5,),
                                          amount?Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white
                                              ),
                                              child: Text(amountError)
                                          ):const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      top: 170,
                      child: Row(
                        children: [
                          fromText == "???"?
                          Image.asset(fromImage,width: 60,height: 60,):
                          CachedNetworkImage(
                            imageUrl: fromImage,width: 60,height: 60),
                          const SizedBox(width: 5,),
                          Text(fromText,style: const TextStyle(fontSize: 25,color: Colors.white),)
                        ],
                      ),
                    ),

                    Positioned(
                      right: 20,
                      top: 170,
                      child: Row(
                        children: [
                          toText == "???"?
                          Image.asset(toImage,width: 60,height: 60,):
                          CachedNetworkImage(
                            imageUrl: toImage,width: 60,height: 60,),
                          const SizedBox(width: 5,),
                          Text(toText,style: const TextStyle(fontSize: 25,color: Colors.white),)
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          height: MediaQuery.of(context).size.height/1.8,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                          ),
                          child: BlocBuilder<CurrencyCubit,CurrencyState>(
                              builder: (BuildContext context, state) {
                                if(state is CurrencyLoadedDB){
                                  fromCurrency = (state).currencies;
                                  toCurrency = (state).currencies;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/3.5,
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(right: 0,bottom: 10,top: 15,left: 10),
                                        padding: const EdgeInsets.only(left: 5,top: 10,bottom: 5,right: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(fromCurrency.length, (index){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        fromImage = fromCurrency[index].flag!;
                                                        fromText = fromCurrency[index].code!;
                                                        fromName = fromCurrency[index].currencyName!;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black),
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CachedNetworkImage(imageUrl: fromCurrency[index].flag!,width: 30,height: 30,errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                          const SizedBox(width: 5,),
                                                          SizedBox(
                                                              width: 50,
                                                              height: 20,
                                                              child: Text(fromCurrency[index].currencyName ?? "")
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10,)
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      Image.asset("assets/image.png",width: MediaQuery.of(context).size.width/3.2,),
                                      Container(
                                        width: MediaQuery.of(context).size.width/3.5,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: 10,bottom: 10,top: 15,left: 0),
                                        padding: const EdgeInsets.only(left: 5,top: 10,bottom: 5,right: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(toCurrency.length, (index){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        toImage = toCurrency[index].flag!;
                                                        toText = toCurrency[index].code!;
                                                        toName = toCurrency[index].currencyName!;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black),
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CachedNetworkImage(imageUrl: toCurrency[index].flag!,width: 30,height: 30,errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                          const SizedBox(width: 5,),
                                                          SizedBox(width: 50,
                                                              height: 20,child: Text(toCurrency[index].currencyName ?? ""))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10,)
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }else if(state is CurrencyLoadedAPI){
                                  fromCurrency = (state).currencies;
                                  toCurrency = (state).currencies;
                                  BlocProvider.of<CurrencyCubit>(context).addAll((state).currencies);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/3.5,
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(right: 0,bottom: 10,top: 15,left: 10),
                                        padding: const EdgeInsets.only(left: 5,top: 10,bottom: 5,right: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(fromCurrency.length, (index){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        fromImage = fromCurrency[index].flag!;
                                                        fromText = fromCurrency[index].code!;
                                                        fromName = fromCurrency[index].currencyName!;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black),
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CachedNetworkImage(imageUrl: fromCurrency[index].flag!,width: 30,height: 30,errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                          const SizedBox(width: 5,),
                                                          SizedBox(
                                                              width: 50,
                                                              height: 20,
                                                              child: Text(fromCurrency[index].currencyName ?? "")
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10,)
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      Image.asset("assets/image.png",width: MediaQuery.of(context).size.width/3.2,),
                                      Container(
                                        width: MediaQuery.of(context).size.width/3.5,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: 10,bottom: 10,top: 15,left: 0),
                                        padding: const EdgeInsets.only(left: 5,top: 10,bottom: 5,right: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(toCurrency.length, (index){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        toImage = toCurrency[index].flag!;
                                                        toText = toCurrency[index].code!;
                                                        toName = toCurrency[index].currencyName!;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black),
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CachedNetworkImage(imageUrl: toCurrency[index].flag!,width: 30,height: 30,errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                          const SizedBox(width: 5,),
                                                          SizedBox(width: 50,
                                                              height: 20,child: Text(toCurrency[index].currencyName ?? ""))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10,)
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }else{
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
                          )
                      ),
                    ),

                    isLoading? Positioned(
                      bottom: MediaQuery.of(context).size.height/2.5,
                      left: 0,
                      right: 0,
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(7,36,249,1),
                          ),
                        ),
                      ),
                    ):const SizedBox.shrink()
                  ],
                ),
              ),
            );
          }else{
            return  Center(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Can\'t connect .. check internet',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                    Image.asset('assets/no_internet.png')
                  ],
                ),
              ),
            );
          }
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(7,36,249,1),
          ),
        ),
      )
    );
  }
}