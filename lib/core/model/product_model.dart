import '../../gen/assets.gen.dart';

class ProductModel {
  final int id;
  final String name;
  final int qtyOfProduct;
  final String rate;
  final String residentNumber;
  final double price;
  final AssetGenImage image;

  ProductModel({
    required this.id,
    required this.name,
    required this.qtyOfProduct,
    required this.rate,
    required this.residentNumber,
    required this.price,
    required this.image,
  });

  get rateWithResidentNum => "$rate ($residentNumber)";

  static List<ProductModel> products = [
    ProductModel(
      id: 1,
      name: "Banana",
      qtyOfProduct: 4,
      price: 3.99,
      rate: "4.8",
      residentNumber: "287",
      image: Assets.products.banana,
    ),
    ProductModel(
      id: 2,
      name: "Pepper",
      qtyOfProduct: 4,
      price: 2.99,
      rate: "4.8",
      residentNumber: "287",
      image: Assets.products.papper,
    ),
    ProductModel(
      id: 3,
      name: "Orange",
      qtyOfProduct: 5,
      price: 1.99,
      rate: "4.8",
      residentNumber: "287",
      image: Assets.products.orange,
    ),
    ProductModel(
      id: 4,
      name: "Lemon",
      qtyOfProduct: 10,
      price: 1.99,
      rate: "4.8",
      residentNumber: "287",
      image: Assets.products.lemon,
    ),
    ProductModel(
      id: 5,
      name: "Purex",
      qtyOfProduct: 1,
      price: 9.99,
      rate: "4.8",
      residentNumber: "287",
      image: Assets.products.purex,
    ),
    ProductModel(
      id: 6,
      name: "Lucker",
      qtyOfProduct: 2,
      price: 4.99,
      rate: "4.8",
      residentNumber: "287",
      image: Assets.products.lucker,
    ),
  ];
}
