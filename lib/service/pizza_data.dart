import 'package:food_delivery_app/model/pizza_model.dart';

List<PizzaModel> getPizza() {
  List<PizzaModel> pizza = [];
  PizzaModel pizzaModel = PizzaModel();

  pizzaModel.name = "Cheese Pizza";
  pizzaModel.image = 'images/pizza1.png';
  pizzaModel.price = "50";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  pizzaModel.name = "Pepper Pizza";
  pizzaModel.image = 'images/pizza2.png';
  pizzaModel.price = "80";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  pizzaModel.name = "Salami Pizza";
  pizzaModel.image = 'images/pizza3.png';
  pizzaModel.price = "40";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  return pizza;
}
