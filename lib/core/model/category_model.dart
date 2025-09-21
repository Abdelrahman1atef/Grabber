import '../../gen/assets.gen.dart';

class CategoryModel {
  final int id ;
  final String name;
  final AssetGenImage image;

  CategoryModel({required this.id, required this.name, required this.image});

  static final List<CategoryModel> category=[
    CategoryModel(id: 1,name: "Fruits",image: Assets.category.fruits),
     CategoryModel(id: 2,name: "Milk & egg",image: Assets.category.egg),
     CategoryModel(id: 3,name: "Beverages",image: Assets.category.bavergas),
     CategoryModel(id: 4,name: "Laundry",image: Assets.category.luandry),
     CategoryModel(id: 5,name: "Vegetables",image: Assets.category.vegatbels),
  ];
}