import 'package:final_project/db/category/category_db.dart';
import 'package:final_project/models/category/category_model.dart';
import 'package:final_project/screens/add_transaction/screen_add_transaction.dart';
import 'package:final_project/screens/category/category_add_popup.dart';
import 'package:final_project/screens/category/screen_category.dart';
import 'package:final_project/screens/home/widgets/bottom_navigation.dart';
import 'package:final_project/screens/transactions/screen_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final pages = const [
    ScreenTransaction(),
    ScreenCategory()
  ];

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();
    return Scaffold(
      appBar: AppBar(title: Text('Wally'), backgroundColor: Color.fromARGB(255, 9, 103, 106),),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context,int updatedIndex,_){
            return pages[updatedIndex];
          }
        ),
      ),
      
      floatingActionButton: FloatingActionButton(onPressed: (){
          if(selectedIndexNotifier.value==0)
          {
            print('Adding Transaction...');
            Navigator.of(context).pushNamed(ScreenaddTransaction.routeName);
          }
          else
          {
            print('Adding Category...');
            showCategoryAddPopup(context);
          }
        }, 
        child: Icon(Icons.add), backgroundColor: Color.fromARGB(255, 9, 103, 106),
      ),
    );
  }
}