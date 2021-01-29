
import 'package:expenses/bll/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TransactionsList extends StatelessWidget {
  final Function deleteHandler;
  final List<Transaction> transactions;
  TransactionsList({@required this.transactions, @required this.deleteHandler}){
    print("again");
  }

  
    
  @override
  Widget build(BuildContext context) {
    return transactions.length ==0 ?
    Container(child: Column(children: [
      Image.asset('assets/Image/people.png',fit: BoxFit.fill,),
      SizedBox(height: 24,), /*To give space*/
      Text("No spendings found!", style: Theme.of(context).textTheme.headline1,),
    ]),
     
    margin: EdgeInsets.only(top: 32),
    ) : 
   
   
    Container( 
    child:
    ListView.builder(/*A list view but only loads what would appear --> better than lazy builder */
      
      itemBuilder: (ctx,index){
        print("idk");
        return Dismissible(

          background: Container(
            color: Colors.amber,
            child: Icon(Icons.delete_outline),
          ),
          direction: DismissDirection.endToStart,
          key: ValueKey(transactions[index].id) ,
          child :Card (margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8) ,child : 
          
          ListTile(
            
            
            leading: Container(
              
              height: 152,
              width: 104,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 2)),
              child: Center(child :Text(transactions[index].amount.toStringAsFixed(2)+"\$", style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),)
            ),

            title: Text(transactions[index].title, style: Theme.of(context).textTheme.subtitle2,),

            subtitle: Text(DateFormat.yMMMMEEEEd().format(transactions[index].pickupdate), style: Theme.of(context).textTheme.caption),

            trailing: const Icon(Icons.delete_outline), onTap: (){deleteHandler(id : transactions[index].id);},
          )),
          onDismissed: (direction){
            
            deleteHandler(id : transactions[index].id);

          },
        );
         
      },
      itemCount: transactions.length,
    ),   
    );
  }
}