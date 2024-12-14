class QRCode {
  final String id;
  final String batchId;
  final String? productId;
  final int pointsValue;
  final bool isScanned;
  final String? scannedBy;
  final DateTime? scannedAt;
  final bool isActive;
  final String? createdBy;
  final DateTime createdAt;

  QRCode({
    required this.id,
    required this.batchId,
    this.productId,
    required this.pointsValue,
    this.isScanned = false,
    this.scannedBy,
    this.scannedAt,
    this.isActive = true,
    this.createdBy,
    required this.createdAt,
  });

  factory QRCode.fromJson(Map<String, dynamic> json) => QRCode(
        id: json['id'],
        batchId: json['batch_id'],
        productId: json['product_id'],
        pointsValue: json['points_value'],
        isScanned: json['is_scanned'],
        scannedBy: json['scanned_by'],
        scannedAt: json['scanned_at'] != null
            ? DateTime.parse(json['scanned_at'])
            : null,
        isActive: json['is_active'],
        createdBy: json['created_by'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'batch_id': batchId,
        'product_id': productId,
        'points_value': pointsValue,
        'is_scanned': isScanned,
        'scanned_by': scannedBy,
        'scanned_at': scannedAt?.toIso8601String(),
        'is_active': isActive,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
      };
}
