import 'package:final_project/models/category/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions{
  Future <List<CategoryModel>> getCategories();
  Future <void> insertCategory(CategoryModel value);
  Future <void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunctions{
  
  CategoryDB.internal();
  static CategoryDB instance = CategoryDB.internal();
  factory CategoryDB(){return instance;}

  ValueNotifier<List<CategoryModel>> incomeCategoryListListener=ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener=ValueNotifier([]);


  @override
  Future<void> insertCategory(CategoryModel value) async{
    final categoryDB =  await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id,value);
    refreshUI();
  }
  
  @override
  Future<List<CategoryModel>> getCategories() async{
    final categoryDB =  await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void>refreshUI() async {
    final allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    Future.forEach(allCategories, (CategoryModel category){
      if(category.type==CategoryType.income)
      incomeCategoryListListener.value.add(category);
      else
      expenseCategoryListListener.value.add(category);      
    });

    incomeCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }
  
  @override
  Future<void> deleteCategory(String categoryID) async{
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(categoryID);
    refreshUI();
  }

}