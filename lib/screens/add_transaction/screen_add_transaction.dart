import 'package:final_project/db/category/category_db.dart';
import 'package:final_project/db/transaction/transaction_db.dart';
import 'package:final_project/models/category/category_model.dart';
import 'package:final_project/models/transaction/transaction_model.dart';
import 'package:flutter/material.dart';

class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenaddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {

  DateTime? selectedDate;
  CategoryType? selectedCategoryType;
  CategoryModel? selectedCategoryModel;
  String? categoryID;

  final purposeTextEdtingController = TextEditingController();
  final amountTextEdtingController = TextEditingController();


  @override
  void initState() {
    selectedCategoryType=CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: purposeTextEdtingController,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                  labelText: 'Purpose',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 135, 6, 6))),
                  prefixIcon: Icon(Icons.square),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: amountTextEdtingController,
                keyboardType: TextInputType.number ,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.currency_rupee),
                )
              ),
            ),

            
            TextButton.icon(
              onPressed: () async {
                final selectedDateTemp = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime.now().subtract(Duration(days: 30)), 
                  lastDate: DateTime.now()
                );
                if(selectedDateTemp==null){return;}
                else{
                  print(selectedDateTemp.toString());    
                  setState(() {
                    selectedDate=selectedDateTemp;
                  }); 
                }     
              }, 
              icon:Icon(Icons.calendar_today_rounded), 
              label: Text(selectedDate==null ? 'Select Date' : selectedDate.toString())
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income, 
                      groupValue: selectedCategoryType, 
                      onChanged: (newValue){
                        setState(() {
                          selectedCategoryType=CategoryType.income;
                          categoryID=null;
                        });
                      }
                    ),
                    Text('Income')
                  ],
                ),

                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense, 
                      groupValue: selectedCategoryType, 
                      onChanged: (newValue){
                
                        setState(() {
                          selectedCategoryType=CategoryType.expense;
                          categoryID=null;
                        });
                      }
                    ),
                    Text('Expense')
                  ],
                ),
              ],
            ),

            DropdownButton(
              hint: Text('Select Category...'),
              value: categoryID,
              items: (
                selectedCategoryType ==CategoryType.income 
                ? CategoryDB().incomeCategoryListListener
                : CategoryDB().expenseCategoryListListener
                ).value.map((e){
                return DropdownMenuItem(
                  child: Text(e.name),
                  value:e.id,
                  onTap: (){
                    selectedCategoryModel=e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue){
                setState(() {
                  categoryID=selectedValue.toString();
                });
              }
            ),

            ElevatedButton.icon(
              onPressed: (){
                addTransaction();
              },
              icon: Icon(Icons.add), 
              label: Text('Add')
            )

          ],),
        )
      )
    );
  }

  Future<void> addTransaction()async{
    final purposeText = purposeTextEdtingController.text;
    final amountText = amountTextEdtingController.text;
    
    if(purposeText.isEmpty || amountText.isEmpty || categoryID==null || selectedDate==null ||selectedCategoryModel==null)
    {return;}

    final parsedAmount = double.tryParse(amountText);
    if(parsedAmount==null){return;}

    //selectedDate
    //selectedCategoryType

    final model = TransactionModel(
      purpose: purposeText, 
      amount: parsedAmount, 
      date: selectedDate!, 
      type: selectedCategoryType!, 
      category: selectedCategoryModel!
    );

    await TransactionDB.instance.addTransaction(model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }

}
