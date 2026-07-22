/// `listar_compras_afiliado/`, `cancelar_pago_afiliado`, paymob, upgrade).
library;

import 'package:dio/dio.dart';

import '../models/payment_dtos.dart';

class PaymentRemoteDataSource {
  PaymentRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<ShopPlanDto>> fetchPlans(String affKey) async {
    final res = await _dio.get<dynamic>(
      'planes',
      queryParameters: {'affkey': affKey},
    );
    return parsePlans(res.data);
  }

  Future<List<ShopServiceDto>> fetchUniqueServices(String affKey) async {
    final res = await _dio.get<dynamic>(
      'detalle_servicio_app/',
      queryParameters: {'affkey': affKey},
    );
    return parseServices(res.data);
  }

  Future<List<PurchaseDto>> fetchPurchases(String affKey) async {
    final res = await _dio.get<dynamic>(
      'listar_compras_afiliado/',
      queryParameters: {'affkey': affKey},
    );
    return parsePurchases(res.data);
  }

  Future<PaymentResultDto> pay(List<Map<String, dynamic>> items) async {
    final res = await _dio.post<dynamic>(
      'soaang-payments/payment-with-provider/paymob',
      data: {'items': items},
      options: Options(contentType: Headers.jsonContentType),
    );
    final dto = PaymentResultDto.tryParse(res.data);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid payment response',
      );
    }
    return dto;
  }

  Future<void> cancel(String purchaseId) async {
    await _dio.post<dynamic>(
      'cancelar_pago_afiliado',
      data: {'id': purchaseId},
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> upgradeAccount(String affKey) async {
    await _dio.post<dynamic>(
      'soaang-catalogs/api/affiliate/upgrade-account/',
      data: {'affkey': affKey},
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
