import 'package:final_project/models/category/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions{
  Future <void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>>getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions{
  TransactionDB.internal();
  static TransactionDB instance = TransactionDB.internal();

  factory TransactionDB(){
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier([]);


  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.put(obj.id, obj);
  }

  Future<void> refresh() async{
    final list = await getAllTransactions();
    list.sort((first,second)=>second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(list);
    transactionListNotifier.notifyListeners();
  }
  
  @override
  Future<List<TransactionModel>> getAllTransactions() async{
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return db.values.toList();
  }
  
  @override
  Future<void> deleteTransaction(String id) async{
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.delete(id);
    refresh();
  }

}