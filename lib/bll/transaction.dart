
import 'package:flutter/foundation.dart';

class Transaction{
  
  String id;
  String title;
  double amount;
  DateTime pickupdate;
  
  Transaction({@required this.id, @required this.title, @required this.amount, @required this.pickupdate}){
    print("new one");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'pickupdate' : pickupdate.toIso8601String()
    };
  }

}