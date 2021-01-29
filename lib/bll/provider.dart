


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import './transaction.dart' as Tx;

class Expenses with ChangeNotifier{

  List<Tx.Transaction> transactions = [];
  bool loaded = false;
  Future<Database> database;

  Future<void> fetchData() async{
    WidgetsFlutterBinding.ensureInitialized();
    // getting db
    try{
      database = openDatabase(
      join(await getDatabasesPath() , 'expenses.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE IF NOT EXISTS transactions(id TEXT PRIMARY KEY, title TEXT, amount REAL, pickupdate TEXT)",
        );
      },
      version: 1,
    );
    // getting db
    print(database);
    await fetchTransactions();
    loaded = true;
    notifyListeners();
    }catch(err){
      print(err.toString());
      throw err;
    }
  }


  Future<void> fetchTransactions() async{
    try{
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('transactions');
      transactions = List.generate(maps.length, (i) {
        return Tx.Transaction(
          id: maps[i]['id'],
          title: maps[i]['title'],
          amount: maps[i]['amount'],
          pickupdate: DateTime.parse(maps[i]['pickupdate'])
        );
      });
      print(transactions);

    }catch (error){
      print(error.toString());
      throw error;
    }
  }

  Future<void> insertTx(Tx.Transaction transaction) async {
    try{
      // Get a reference to the database.
      final Database db = await database;

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      transactions.add(transaction);
      print("added tx");
      notifyListeners();
    }catch(error){
      print(error.toString());
      throw error;
    }
  }

  Future<void> deleteTx(String id) async{
    try{
      // Get a reference to the database.
      final Database db = await database;

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      
      await db.delete(
        'transactions',
        // Use a `where` clause to delete a specific dog.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );

      transactions.removeWhere((element){
        return element.id == id;
      });

      print("removed tx");
      notifyListeners();
    }catch(error){
      print(error.toString());
      throw error;
    }
  }
  

}