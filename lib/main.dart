
import 'package:expenses/widgets/Colors.dart';
import 'package:expenses/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bll/transaction.dart';
import 'widgets/NewTransaction.dart';
import 'widgets/transactionList.dart';

//MediaQuery widget take the context by using MediaQuery.of(context) then give you the height and width of the actual device, this would be interesting when building an app that fits every phone!

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
} 
  //Sets the wanted oriontation
  //To check what Orientation our device is on now
  //MediaQuery.of(context).orientation == Orientation.landscape || Orientation.portrait
 


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: "Expenses",
      theme: ThemeData(/**Setting the theme for the app**/

        primarySwatch: primaryColor(),/**Main Color**/
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        /*behind the bottom sheet lays a canvas, give it a transparent color and manipulate the container only*/

        textTheme: ThemeData.light().textTheme.copyWith(/**Text theme by name**/
          headline1: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500 ,fontSize: 24, height: 28),
          subtitle1: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400 ,fontSize: 16,height: 24),
          headline2: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500 ,fontSize: 18,height: 24),
          subtitle2: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w600 ,fontSize: 12,height: 16),
          headline3: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500 ,fontSize: 14,height: 20),
          bodyText1: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400 ,fontSize: 14,height: 20),
          caption: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400 ,fontSize: 12,height: 20),
        ),
        
      ),
      home: ExpensesApp(),
    );
  }
}


class ExpensesApp extends StatefulWidget {
  @override
  ExpensesAppState createState() => ExpensesAppState();
}
/*Mixins are used to let you extend from diffrent classes, use the keyword "with" followed by the name of the class aimed, exemple :*/
class ExpensesAppState extends State<ExpensesApp> with WidgetsBindingObserver {//widgetBindingObserver holds the app lifecycle states (inactive, paused, resumed and suspending)

  final List<Transaction> _transactions = [];
  
  List<Transaction> get _recentTr{
  
    return _transactions.where((tx){
      return tx.pickupdate.isAfter(
        DateTime.now().subtract(Duration(days: 7))
      );
    }).toList();
  }/*Passing only this weeks transactions*/

  /*App lifecycle implem : */
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);// handler of state changing
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }//add the listener

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();/**Clear Listeners from memory when done with states */
  }


  void addTransaction({@required String title,@required double amount,@required DateTime pickUpDate}){
    setState(() {
      _transactions.add(Transaction(id: DateTime.now().toString(), title: title,amount: amount, pickupdate: pickUpDate));
    });
  }/*Method to call when we want to add transactions */

  void deleteTransaction({@required id}){
    setState(() {
      _transactions.removeWhere((element){
        return element.id == id;
      });
    });
  }
  
  void _showNewTransaction(context){
    showModalBottomSheet(context: context, builder: (_){ return Theme(data: Theme.of(context).copyWith(canvasColor: Colors.transparent) ,child: NewTransaction(eventHandler: addTransaction),);});
  }/*The bottom sheet */
  
  @override
  Widget build(BuildContext context) {
    final _appbar = AppBar(
      title: const Center(
        child: Text("Expensify"),            
      ),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appbar,
      body: Column(/*So that the app can be scrolled*/

        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
          
        children: <Widget>[//mediaQuery.of(context).padding.top is the top bar, the appbar one is appbar.pref..... wev done this in order to get the main panel  size only
          Container( height :(MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - _appbar.preferredSize.height)* ((_transactions.length == 0)?0:0.25),
            child: Chart(transactions :_recentTr),
          ),
            
          Container( height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - _appbar.preferredSize.height)* ((_transactions.length == 0)?1:0.75),
            child: TransactionsList(transactions : this._transactions,deleteHandler: this.deleteTransaction,),
          )

        ],
      ),
      floatingActionButtonLocation: (_transactions.length == 0)?FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat, 
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: ()=> _showNewTransaction(this.context),),

  );
  }
}