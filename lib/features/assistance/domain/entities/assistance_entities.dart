/// Assistance entities (AFILIADO catalog + assistance creation flow).
/// Pure Dart.
library;

/// Affiliate account (AFILIADO `get-affiliate-accounts`).
class Account {
  const Account({required this.id, required this.name, this.number});
  final String id;
  final String name;
  final String? number;
}

/// Plan under an account (AFILIADO `get-affiliate-plans`).
class Plan {
  const Plan({required this.id, required this.name, this.description});
  final String id;
  final String name;
  final String? description;
}

/// Family of services under a plan (AFILIADO `get-affiliate-family-services`).
class ServiceFamily {
  const ServiceFamily({required this.id, required this.name});
  final String id;
  final String name;
}

/// Service within a family (AFILIADO `get-affiliate-plan-services` /
/// `metadata-service`).
class Service {
  const Service({required this.id, required this.name, this.description, this.familyId});
  final String id;
  final String name;
  final String? description;
  final String? familyId;
}

/// Coverage question for an assistance (AFILIADO `obtener_preguntas_cobertura`).
class CoverageQuestion {
  const CoverageQuestion({required this.id, required this.text, required this.options});
  final String id;
  final String text;
  final List<String> options;
}

/// A selected coverage answer (AFILIADO `guardar_pregunta_cobertura_afiliado`).
class CoverageAnswer {
  const CoverageAnswer({required this.questionId, required this.answer});
  final String questionId;
  final String answer;
}

/// The created assistance (AFILIADO `CreateAssistanceResponse`).
class Assistance {
  const Assistance({required this.id, required this.serviceId, this.status});
  final String id;
  final String serviceId;
  final String? status;
}

/// Google Places autocomplete suggestion (AFILIADO `v1/places:autocomplete`).
class PlaceSuggestion {
  const PlaceSuggestion({required this.placeId, required this.description});
  final String placeId;
  final String description;
}

/// Resolved place location (AFILIADO `v1/places/{placeId}` / geocode).
class PlaceLocation {
  const PlaceLocation({required this.placeId, this.lat, this.lng, this.formattedAddress});
  final String placeId;
  final double? lat;
  final double? lng;
  final String? formattedAddress;
}