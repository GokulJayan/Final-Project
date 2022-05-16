import 'package:final_project/db/category/category_db.dart';
import 'package:final_project/screens/category/expense_category_list.dart';
import 'package:final_project/screens/category/income_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> with SingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState(){
    tabController=TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.black,
          indicatorColor: Color.fromARGB(255, 9, 103, 106),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Income',),
            Tab(text: 'Expense',),
          ]
        ),

        Expanded(
          child: TabBarView(
            controller: tabController,
            children:const [
              IncomeCategoryList(),
              ExpenseCategoryList()
            ] 
          ),
        )
      ],
    );
  }
}