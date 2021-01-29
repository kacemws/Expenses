
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
  final focus = FocusNode();
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

  void dispose() {
    print('dont do shit');
    super.dispose();/**Clear Listeners from memory when done with states */
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        
        //margin: EdgeInsets.fromLTRB(20, 12, 20, 88),
        color: Color(0xfff4f5f7),
        child : Container( padding: EdgeInsets.only(top: 16, left: 16,right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),/*To raise the container whenever a keyboard is out */
        child: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          
          TextField(
            decoration: InputDecoration(labelText: "title : ", labelStyle: Theme.of(context).textTheme.subtitle1),
            controller: titleController,
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              FocusScope.of(context).requestFocus(focus);
            },
            /* We couldve used on change : (aux){ ourVar = aux;}*/
          ),
          TextField(
            focusNode: focus,
            decoration: InputDecoration(labelText: "amount : ", labelStyle: Theme.of(context).textTheme.subtitle1),
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_)=> submitData(),
          ),

          Container(
            margin: EdgeInsets.all(15),
            child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text((selectedDate == null)?"Pick Up a date" : "Selected date :"+ DateFormat.yMd().format(selectedDate), style: Theme.of(context).textTheme.bodyText1,),
              IconButton(icon: Icon(Icons.calendar_today),onPressed: selectdate,color: Color(0xff181818),)
            ],),
          ),
          Container(
            margin:const EdgeInsets.all(15),
            height : 40,
            child :RaisedButton(
            child: Text("Submit", style: Theme.of(context).textTheme.headline3.copyWith(
              color: Color(( (titleController?.text ?? "")?.isEmpty || amountController?.text?.isEmpty || amountController?.text == '0' || selectedDate == null)? 0xff181818 : 0xfffbf4e4)
            ),),
            disabledColor: Color(0xffe1e1e1),
            color: Color(0xff1d888a),
            onPressed: ( (titleController?.text ?? "")?.isEmpty || amountController?.text?.isEmpty || amountController?.text == '0' || selectedDate == null)? null : submitData,
          )),
        ],
      ),),)
    );}
}
