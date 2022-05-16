import 'package:final_project/screens/home/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? _){
        return BottomNavigationBar(
          selectedItemColor: Color.fromARGB(255, 9, 103, 106) ,
          unselectedItemColor: Colors.grey,
          currentIndex: updatedIndex,
          
          onTap: (newIndex){
            ScreenHome.selectedIndexNotifier.value=newIndex;
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Transactions'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          ]
        );
      }, 
    );
  }
}