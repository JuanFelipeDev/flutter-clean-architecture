/// `listar_compras_afiliado/`, paymob response).
library;

import 'dart:convert';

import '../../domain/entities/payment_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

double? _toDouble(dynamic v) => v is num ? v.toDouble() : null;

class ShopPlanDto {
  const ShopPlanDto({this.id, this.name, this.price, this.currency, this.type});
  final String? id;
  final String? name;
  final double? price;
  final String? currency;
  final String? type;
  factory ShopPlanDto.fromJson(Map<String, dynamic> json) => ShopPlanDto(
    id: json['idplan']?.toString() ?? json['id']?.toString(),
    name: json['name']?.toString() ?? json['plan']?.toString(),
    price: _toDouble(json['price'] ?? json['costo']),
    currency: json['currency']?.toString() ?? json['moneda']?.toString(),
    type: json['type']?.toString() ?? json['tipo']?.toString(),
  );
}

class ShopServiceDto {
  const ShopServiceDto({
    this.id,
    this.name,
    this.price,
    this.currency,
    this.description,
  });
  final String? id;
  final String? name;
  final double? price;
  final String? currency;
  final String? description;
  factory ShopServiceDto.fromJson(Map<String, dynamic> json) => ShopServiceDto(
    id: json['idService']?.toString() ?? json['id']?.toString(),
    name: json['name']?.toString() ?? json['servicio']?.toString(),
    price: _toDouble(json['price'] ?? json['costo']),
    currency: json['currency']?.toString() ?? json['moneda']?.toString(),
    description: json['description']?.toString(),
  );
}

class PurchaseDto {
  const PurchaseDto({
    this.id,
    this.itemType,
    this.itemId,
    this.name,
    this.price,
    this.quantity,
  });
  final String? id;
  final String? itemType;
  final String? itemId;
  final String? name;
  final double? price;
  final int? quantity;
  factory PurchaseDto.fromJson(Map<String, dynamic> json) => PurchaseDto(
    id: json['id']?.toString(),
    itemType: json['item_type']?.toString() ?? json['tipo']?.toString(),
    itemId: json['item_id']?.toString() ?? json['iditem']?.toString(),
    name: json['name']?.toString() ?? json['nombre']?.toString(),
    price: _toDouble(json['price'] ?? json['costo']),
    quantity: json['quantity'] is int ? json['quantity'] as int : 1,
  );
}

class PaymentResultDto {
  const PaymentResultDto({
    this.success,
    this.paymentUrl,
    this.referenceId,
    this.message,
  });
  final bool? success;
  final String? paymentUrl;
  final String? referenceId;
  final String? message;
  factory PaymentResultDto.fromJson(Map<String, dynamic> json) =>
      PaymentResultDto(
        success: json['success'] is bool
            ? json['success'] as bool
            : json['redirect_url'] != null,
        paymentUrl:
            json['redirect_url']?.toString() ?? json['payment_url']?.toString(),
        referenceId: json['reference_id']?.toString() ?? json['id']?.toString(),
        message: json['message']?.toString(),
      );

  static PaymentResultDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return PaymentResultDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>)
        return PaymentResultDto.fromJson(decoded);
    }
    return null;
  }
}

class PaymentMapper {
  const PaymentMapper();

  ShopPlan toPlan(ShopPlanDto dto) => ShopPlan(
    id: dto.id ?? '',
    name: dto.name ?? '',
    price: dto.price ?? 0,
    currency: dto.currency,
    type: dto.type,
  );

  ShopService toService(ShopServiceDto dto) => ShopService(
    id: dto.id ?? '',
    name: dto.name ?? '',
    price: dto.price ?? 0,
    currency: dto.currency,
    description: dto.description,
  );

  Purchase toPurchase(PurchaseDto dto) => Purchase(
    id: dto.id ?? '',
    itemType: (dto.itemType == 'service')
        ? PaymentItemType.service
        : PaymentItemType.plan,
    itemId: dto.itemId ?? '',
    name: dto.name ?? '',
    price: dto.price ?? 0,
    quantity: dto.quantity ?? 1,
  );

  PaymentResult toResult(PaymentResultDto dto) => PaymentResult(
    success: dto.success ?? false,
    paymentUrl: dto.paymentUrl,
    referenceId: dto.referenceId,
    message: dto.message,
  );
}

List<ShopPlanDto> parsePlans(dynamic body) =>
    parseJsonList(body, ShopPlanDto.fromJson, 'plans');
List<ShopServiceDto> parseServices(dynamic body) =>
    parseJsonList(body, ShopServiceDto.fromJson, 'services');
List<PurchaseDto> parsePurchases(dynamic body) =>
    parseJsonList(body, PurchaseDto.fromJson, 'purchases');
