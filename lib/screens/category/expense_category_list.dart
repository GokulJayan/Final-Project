import 'package:final_project/db/category/category_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget?_){
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final category = newList[index];
                return Card(
                  child: ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                        onPressed: () {
                          CategoryDB.instance.deleteCategory(category.id);
                        },
                        icon: Icon(Icons.delete, color: Colors.red)),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return SizedBox(height: 10);
              },
              itemCount: newList.length);
        });
  }
}
