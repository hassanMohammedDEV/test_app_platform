class ProductStateModel {
  final String? title;
  final String? description;
  final double? price;
  final String? code;
  final String? website;

  ProductStateModel({
    this.title,
    this.description,
    this.price,
    this.code,
    this.website,
  });

  ProductStateModel copyWith({
    String? title,
    String? description,
    double? price,
    String? code,
    String? website,
  }) {
    return ProductStateModel(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      code: code ?? this.code,
      website: website ?? this.website,
    );
  }
}
