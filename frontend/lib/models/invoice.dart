class SalesInvoice {
  final int id;
  final String invoiceNumber;
  final int customerId;
  final double total;
  final double discount;
  final double netTotal;
  final double paid;
  final String paymentType;
  final String? notes;
  final List<SalesItem> items;

  SalesInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.customerId,
    required this.total,
    required this.discount,
    required this.netTotal,
    required this.paid,
    required this.paymentType,
    this.notes,
    required this.items,
  });

  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    return SalesInvoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      customerId: json['customer_id'],
      total: (json['total'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      netTotal: (json['net_total'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      paymentType: json['payment_type'],
      notes: json['notes'],
      items: (json['items'] as List?)
              ?.map((e) => SalesItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SalesItem {
  final int id;
  final int productId;
  final double quantity;
  final double unitPrice;
  final double total;

  SalesItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) {
    return SalesItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class PurchaseInvoice {
  final int id;
  final String invoiceNumber;
  final int supplierId;
  final double total;
  final double paid;
  final String paymentType;
  final String? notes;
  final List<PurchaseItem> items;

  PurchaseInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.supplierId,
    required this.total,
    required this.paid,
    required this.paymentType,
    this.notes,
    required this.items,
  });

  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      supplierId: json['supplier_id'],
      total: (json['total'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      paymentType: json['payment_type'],
      notes: json['notes'],
      items: (json['items'] as List?)
              ?.map((e) => PurchaseItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PurchaseItem {
  final int id;
  final int productId;
  final double quantity;
  final double unitPrice;
  final double total;

  PurchaseItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}
