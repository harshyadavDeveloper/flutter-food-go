import 'package:food_delivery_app/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel();

  categoryModel.name = 'Pizza';
  categoryModel.image = 'images/pizza.png';
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = 'Burger';
  categoryModel.image = 'images/burger.png';
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = 'Chinese';
  categoryModel.image = 'images/chinese.png';
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = 'Mexican';
  categoryModel.image = 'images/tacos.png';
  category.add(categoryModel);
  categoryModel = CategoryModel();

  return category;
}
