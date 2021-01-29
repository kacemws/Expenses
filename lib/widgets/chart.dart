
import 'package:expenses/bll/transaction.dart';
import 'package:expenses/widgets/ChartBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactions;
  Chart({@required this.transactions});
  
  List<Map<String,Object>> get _chartMap {
    return List.generate(7, (index){/*to generate a list of 7 items from 0 to 6*/

      final weekDay = DateTime.now().subtract(Duration(days: index));
      double sum = 0;
      for(var i = 0; i< transactions.length; i++)
        if(transactions[i].pickupdate.day == weekDay.day && transactions[i].pickupdate.month == weekDay.month && transactions[i].pickupdate.year == weekDay.year){
          sum+= transactions[i].amount;
        }
      return {"Day" : DateFormat.E().format(weekDay).substring(0,1), "Amount" :  sum};/*Return a map of <string : object>*/

    }).reversed.toList();//reverse the list then put it back in that list
  }
  double _getTotalSpendings(){
    return _chartMap.fold(0.0, (sum, item){
      return sum+= item["Amount"];/*Sum of all items in table*/ 
    });
  }
  @override
  Widget build(BuildContext context) {
    //print(_chartMap);
    return (transactions.length != 0)? Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(15),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: 
        
          _chartMap.map((day){/*Flexible to let the child take more size */
            return Flexible(child: ChartBar(label: day["Day"], amount: day["Amount"], totalSpendings:1 - (day["Amount"] as double)/_getTotalSpendings()));
          }).toList(),
        ),
      ),
      
    ) : const SizedBox(height: 0,);
  }
}