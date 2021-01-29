
import 'package:expenses/bll/provider.dart';
import 'package:expenses/widgets/Colors.dart';
import 'package:expenses/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Expenses())
      ],
      child: Consumer<Expenses>(

        builder: (context, auth, _) => MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: "Expenses",
      theme: ThemeData(/**Setting the theme for the app**/

        primarySwatch: primaryColor(),/**Main Color**/
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        /*behind the bottom sheet lays a canvas, give it a transparent color and manipulate the container only*/

        textTheme: ThemeData.light().textTheme.copyWith(/**Text theme by name**/
          headline1: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500 ,fontSize: 24, height: 1.15, color: Color(0xff181818)),
          subtitle1: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400 ,fontSize: 16,height: 1.5,color: Color(0xff181818)),
          headline2: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500 ,fontSize: 18,height: 1.33,color: Color(0xff181818)),
          subtitle2: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w600 ,fontSize: 12,height: 1.33,color: Color(0xff181818)),
          headline3: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500 ,fontSize: 14,height: 1.42,color: Color(0xff181818)),
          bodyText1: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400 ,fontSize: 14,height: 1.42,color: Color(0xff181818)),
          caption: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400 ,fontSize: 12,height: 1.66,color: Color(0xff181818)),
        ),
        
      ),
      home: ExpensesApp(),
    )
  
      )
    );
    }
}


class ExpensesApp extends StatefulWidget {
  @override
  ExpensesAppState createState() => ExpensesAppState();
}
/*Mixins are used to let you extend from diffrent classes, use the keyword "with" followed by the name of the class aimed, exemple :*/
class ExpensesAppState extends State<ExpensesApp> with WidgetsBindingObserver {//widgetBindingObserver holds the app lifecycle states (inactive, paused, resumed and suspending)

  List<Transaction> _transactions = [];
  Expenses provider;
  
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
    super.didChangeAppLifecycleState(state);// handler of state changing
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero).then((_) async{

      Provider.of<Expenses>(context, listen: false).fetchData();
    });
    super.initState();
  }//add the listener

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();/**Clear Listeners from memory when done with states */
  }


  void addTransaction({@required String title,@required double amount,@required DateTime pickUpDate}){
    provider.insertTx(Transaction(id: DateTime.now().toString(), title: title,amount: amount, pickupdate: pickUpDate));
  }/*Method to call when we want to add transactions */

  void deleteTransaction({@required id}){
    provider.deleteTx(id);
  }
  
  void _showNewTransaction(context){
    showModalBottomSheet(context: context, builder: (_){ return Theme(data: Theme.of(context).copyWith(canvasColor: Colors.transparent) ,child: NewTransaction(eventHandler: addTransaction),);});
  }/*The bottom sheet */
  
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Expenses>(context, listen: true);
    print('rebuild');
    _transactions = provider.transactions;
    final _appbar = AppBar(
      title: Center(
        child: Text(
          "Expensify", 
          style: Theme.of(context).textTheme.headline1.copyWith(
            color: Color(0xfffbf4e4)
          )
        ),            
      ),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appbar,
      body: provider.loaded? Column(/*So that the app can be scrolled*/

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
      ) : Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
                      child: const CircularProgressIndicator(),
        ),
      ),
      floatingActionButtonLocation: (_transactions.length == 0)?FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat, 
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add, color: Color(0xfffbf4e4),), onPressed: ()=> _showNewTransaction(this.context),),

  );
  }
}