
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
      SizedBox(height: 20,), /*To give space*/
      const Text("No spendings found!"),
    ]),
     
    margin: EdgeInsets.only(top: 30),
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
          child :Card (margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5) ,child : 
          
          ListTile(
            
            
            leading: Container(
              
              height: 150,
              width: 100,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 2)),
              child: Center(child :Text(transactions[index].amount.toStringAsFixed(2)+"\$", style: Theme.of(context).textTheme.body1, textAlign: TextAlign.center,),)
            ),

            title: Text(transactions[index].title, style: Theme.of(context).textTheme.title,),

            subtitle: Text(DateFormat.yMMMMEEEEd().format(transactions[index].pickupdate), style: Theme.of(context).textTheme.subtitle),

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