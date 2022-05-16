import 'package:final_project/db/category/category_db.dart';
import 'package:final_project/models/category/category_model.dart';
import 'package:flutter/material.dart';

ValueNotifier <CategoryType> selectedCategoryNotifier = ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async{
  final nameEditingController = TextEditingController();
  showDialog(
    context: context, 
    builder: (ctx){
      return SimpleDialog(
        title: Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller:nameEditingController,
              decoration: InputDecoration(
                hintText: 'Type Category...',
                border: OutlineInputBorder()
              ),
            ),
          ),

          Row(children: [
            RadioButton(title: 'Income', type: CategoryType.income),
            RadioButton(title: 'Expense', type: CategoryType.expense),
          ],),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: (){
                final name = nameEditingController.text;
                if(name.isEmpty)
                {return;}

                final type= selectedCategoryNotifier.value;
                final category= CategoryModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, type: type);

                CategoryDB.instance.insertCategory(category);
                Navigator.of(ctx).pop();
              }, 
              child: Text('Add'), 
              style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 9, 103, 106)))
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  const RadioButton({Key? key, required this.title,required this.type}) : super(key: key);
  final String title;
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier, 
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _){
            return Radio<CategoryType>(
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Color.fromARGB(255, 9, 103, 106);
                }
                return Color.fromARGB(255, 9, 103, 106);
              }),            
              value: type, 
              groupValue: selectedCategoryNotifier.value, 
              onChanged: (value){
                if(value==null){return;}
                selectedCategoryNotifier.value=value;
                selectedCategoryNotifier.notifyListeners();
              }
            );
          }
        ),
        Text(title)
      ],
    );
  }
}