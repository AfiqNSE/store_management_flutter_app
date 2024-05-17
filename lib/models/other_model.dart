class Customer {
  int customerId;
  String customerName;

  Customer({
    required this.customerId,
    required this.customerName,
  });

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
        customerId: map["customerId"],
        customerName: map["customerName"],
      );
}
