
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class NewTransaction extends StatefulWidget {

  final Function eventHandler;
  

  NewTransaction({@required this.eventHandler,});
  @override
  NewTransactionState createState() => NewTransactionState();
}

class NewTransactionState extends State<NewTransaction>{
  
  final titleController = TextEditingController();/*To receive the input*/
  final amountController = TextEditingController();
  var selectedDate;

  

  void submitData(){
    var title = titleController.text;
    var amount = double.parse(amountController.text);
    
    /*Checking datas!!*/
    if(title.isEmpty || amount <=0 || selectedDate == null){
      print("One of the inputs is wrong!");
      return;
    }
    widget.eventHandler(title : title, amount : amount, pickUpDate: selectedDate);
    Navigator.of(context).pop();
  }
  void selectdate(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(1940), 
      lastDate: DateTime.now(), 
       
    ).then(
      (pickedDate){
        if(pickedDate == null)
          return;
        setState(() {
          selectedDate = pickedDate;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        
        //margin: EdgeInsets.fromLTRB(20, 12, 20, 88),
        color: Colors.white,
        child : Container( padding: EdgeInsets.only(top: 10, left: 10,right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),/*To raise the container whenever a keyboard is out */
        child: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          
          TextField(
            decoration: const InputDecoration(labelText: "title : "),
            controller: titleController,
            /* We couldve used on change : (aux){ ourVar = aux;}*/
          ),
          TextField(
            decoration: const InputDecoration(labelText: "amount : "),
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_)=> submitData(),
          ),

          Container(
            margin: EdgeInsets.all(15),
            child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text((selectedDate == null)?"Pick Up a date" : "Selected date :"+ DateFormat.yMd().format(selectedDate), style: Theme.of(context).textTheme.caption,),
              IconButton(icon: Icon(Icons.calendar_today),onPressed: selectdate,color: Colors.black,)
              //Text("Pick Up a date", style: Theme.of(context).textTheme.title,)
            ],),
          ),
          Container(margin:const EdgeInsets.all(15),height : 45,child :RaisedButton(
            child: Text("Submit", style: Theme.of(context).textTheme.title,),
            color: Theme.of(context).primaryColor,
            onPressed: submitData,
          )),
        ],
      ),),)
    );}
}
