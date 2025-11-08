class Shipment {
  final String orderId;
  final String from;
  final String to;
  final String status;
  final String placedDate;
  final String estimatedDate;
  final int currentStep;
  final String? fromAddress;
  final String? toAddress;

  Shipment({
    required this.orderId,
    required this.from,
    required this.to,
    required this.status,
    required this.placedDate,
    required this.estimatedDate,
    required this.currentStep,
    this.fromAddress,
    this.toAddress,
  });
}
