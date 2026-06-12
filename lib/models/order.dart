class Order {
  final String id;
  final String date;
  final String status;
  final double total;
  final List<OrderItem> items;
  final String shippingAddress;
  final String paymentMethod;

  const Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
  });
}

class OrderItem {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}
