import 'package:food_delivery_app/model/burger_model.dart';

List<BurgerModel> getBurger() {
  List<BurgerModel> burger = [];
  BurgerModel burgerModel = BurgerModel();

  burgerModel.name = "Spicy Burger";
  burgerModel.image = 'images/burger1.png';
  burgerModel.price = "50";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  burgerModel.name = "Mayo Burger";
  burgerModel.image = 'images/burger2.png';
  burgerModel.price = "80";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  burgerModel.name = "Veg Burger";
  burgerModel.image = 'images/burger.png';
  burgerModel.price = "40";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  return burger;
}
