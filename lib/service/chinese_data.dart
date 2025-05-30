import 'package:food_delivery_app/model/chinese_model.dart';

List<ChineseModel> getChinese() {
  List<ChineseModel> chinese = [];

  ChineseModel chineseModel = ChineseModel();

  chineseModel.name = "Fried Rice";
  chineseModel.image = 'images/chinese2.png';
  chineseModel.price = "50";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Noodles";
  chineseModel.image = 'images/chinese1.png';
  chineseModel.price = "50";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Lollypop";
  chineseModel.image = 'images/chinese3.png';
  chineseModel.price = "80";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  return chinese;
}
