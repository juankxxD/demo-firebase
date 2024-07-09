class ProductModel {
  String name;
  String description;
  int quantity;
  int value; // Opcional, según los datos del usuario

  ProductModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'value': value,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      value: json['value'],
    );
  }
}
