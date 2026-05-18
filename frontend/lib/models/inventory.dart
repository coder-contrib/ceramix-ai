class Product {
  final int id;
  final String name;
  final String sku;
  final String? description;
  final String unit;
  final double costPrice;
  final double sellPrice;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    this.description,
    required this.unit,
    required this.costPrice,
    required this.sellPrice,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      description: json['description'],
      unit: json['unit'],
      costPrice: (json['cost_price'] as num).toDouble(),
      sellPrice: (json['sell_price'] as num).toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'sku': sku,
        'description': description,
        'unit': unit,
        'cost_price': costPrice,
        'sell_price': sellPrice,
        'category': category,
      };
}

class Warehouse {
  final int id;
  final String name;
  final String? location;

  Warehouse({required this.id, required this.name, this.location});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}

class InventoryItem {
  final int id;
  final int productId;
  final int warehouseId;
  final double quantity;

  InventoryItem({
    required this.id,
    required this.productId,
    required this.warehouseId,
    required this.quantity,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      productId: json['product_id'],
      warehouseId: json['warehouse_id'],
      quantity: (json['quantity'] as num).toDouble(),
    );
  }
}
