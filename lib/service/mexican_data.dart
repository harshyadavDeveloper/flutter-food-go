import 'package:food_delivery_app/model/mexican_model.dart';

List<MexicanModel> getMexican() {
  List<MexicanModel> mexican = [];
  MexicanModel mexicanModel = MexicanModel();

  mexicanModel.name = "Taco";
  mexicanModel.image = 'images/mexican1.png';
  mexicanModel.price = "50";
  mexican.add(mexicanModel);
  mexicanModel = MexicanModel();

  mexicanModel.name = "Enchiladas";
  mexicanModel.image = 'images/mexican2.png';
  mexicanModel.price = "60";
  mexican.add(mexicanModel);

  return mexican;
}
