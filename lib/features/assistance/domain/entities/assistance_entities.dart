/// Pure Dart.
library;

class Account {
  const Account({required this.id, required this.name, this.number});
  final String id;
  final String name;
  final String? number;
}

class Plan {
  const Plan({required this.id, required this.name, this.description});
  final String id;
  final String name;
  final String? description;
}

class ServiceFamily {
  const ServiceFamily({required this.id, required this.name});
  final String id;
  final String name;
}

/// `metadata-service`).
class Service {
  const Service({
    required this.id,
    required this.name,
    this.description,
    this.familyId,
  });
  final String id;
  final String name;
  final String? description;
  final String? familyId;
}

class CoverageQuestion {
  const CoverageQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
  final String id;
  final String text;
  final List<String> options;
}

class CoverageAnswer {
  const CoverageAnswer({required this.questionId, required this.answer});
  final String questionId;
  final String answer;
}

class Assistance {
  const Assistance({required this.id, required this.serviceId, this.status});
  final String id;
  final String serviceId;
  final String? status;
}
