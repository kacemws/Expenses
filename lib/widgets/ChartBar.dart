

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double amount;
  final String label;
  final double totalSpendings; /*Percentage from the total spending*/
  ChartBar({@required this.amount, @required this.label, @required this.totalSpendings});
  
  @override
  Widget build(BuildContext context) {
    //print(totalSpendings);
    return LayoutBuilder(builder: (ctx,constraints){
      return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Container(margin: EdgeInsets.only(top: constraints.maxHeight*0.05),height: constraints.maxHeight*0.15,child:Text(label, style: Theme.of(context).textTheme.headline2,)),

        SizedBox(height: constraints.maxHeight*0.05,),
        Container(

          height: constraints.maxHeight*0.5,
          width: constraints.maxWidth*0.25,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          
          child: Stack(/*Place elements on top of each other*/
            children: <Widget>[
              Container(
                color: Color(0xfffec843),
              ),
              FractionallySizedBox(
                heightFactor: totalSpendings,
                
                child: Container(color: Theme.of(context).primaryColor),
              )
            ]
          ),
        ),
        SizedBox(height: constraints.maxHeight*0.05,),
        Container(margin: EdgeInsets.only(bottom: constraints.maxHeight*0.05),height: constraints.maxHeight*0.15, child: FittedBox(child: Text(amount.toString(), style: Theme.of(context).textTheme.bodyText1),))/*So that the child would stay in the container box*/
        
      ],);
    },);
  }
}