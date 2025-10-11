class PaymentModel {
  final int id;
  final String client;
  final String teaser;
  final double amount;
  final String type;
  final String status;
  final String gatewayId;

  PaymentModel({
    required this.id,
    required this.client,
    required this.teaser,
    required this.amount,
    required this.type,
    required this.status,
    required this.gatewayId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json['id'],
        client: json['client'],
        teaser: json['teaser'],
        amount: json['amount']?.toDouble(),
        type: json['type'],
        status: json['status'],
        gatewayId: json['gateway_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'client': client,
        'teaser': teaser,
        'amount': amount,
        'type': type,
        'status': status,
        'gateway_id': gatewayId,
      };
}