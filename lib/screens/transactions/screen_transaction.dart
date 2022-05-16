import 'package:final_project/db/transaction/transaction_db.dart';
import 'package:final_project/models/category/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../db/category/category_db.dart';
import '../../models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
const ScreenTransaction({Key? key}) : super(key: key);

  static const months = ['','Jan','Feb','Mar','Apr','May','Apr','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
              padding: EdgeInsets.all(10),
              
              itemBuilder: (ctx, index) {
                final value= newList[index];
                return Slidable(
                  key: Key(value.id!),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx){
                          TransactionDB.instance.deleteTransaction(value.id!);                  
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      )
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text( 
                            '  ${months[value.date.month]} \n   ${value.date.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        radius: 65,
                        backgroundColor: value.type == CategoryType.income? Colors.green : Colors.red,
                      ),
                                
                      title: Text('₹ ${value.amount}'),
                      subtitle: Text(value.category.name),
                    ),
                  ),
                );
              },
              
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length
            );
        });
  }
}
