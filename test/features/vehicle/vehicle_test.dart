import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/features/vehicle/data/models/vehicle_dtos.dart';
import 'package:affiliate_app/features/vehicle/domain/entities/vehicle_entities.dart';
import 'package:affiliate_app/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:affiliate_app/features/vehicle/presentation/providers/vehicle_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeVehicleRepository implements VehicleRepository {
  List<Vehicle> store = [];
  String? lastModelsBrandId;

  @override
  Future<Result<List<Vehicle>>> list(String affKey) async => Success(List.of(store));
  @override
  Future<Result<Vehicle>> create(String affKey, Vehicle vehicle) async {
    final created = Vehicle(
      id: 'new-${store.length}',
      plate: vehicle.plate,
      brandId: vehicle.brandId,
      modelId: vehicle.modelId,
      color: vehicle.color,
    );
    store.add(created);
    return Success(created);
  }
  @override
  Future<Result<void>> disable(String vehicleId) async {
    store = store.where((v) => v.id != vehicleId).toList();
    return Result<void>.guard(() {});
  }
  @override
  Future<Result<List<Brand>>> brands() async => const Success([
        Brand(id: 'b1', name: 'Toyota'),
        Brand(id: 'b2', name: 'Honda'),
      ]);
  @override
  Future<Result<List<VehicleModel>>> models(String brandId) async {
    lastModelsBrandId = brandId;
    return const Success([
      VehicleModel(id: 'm1', brandId: 'b1', name: 'Corolla'),
      VehicleModel(id: 'm2', brandId: 'b1', name: 'Yaris'),
    ]);
  }
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('VehicleMapper', () {
    const mapper = VehicleMapper();
    test('round-trips entity <-> dto', () {
      const v = Vehicle(id: '1', plate: 'ABC', brandId: 'b1', modelId: 'm1', color: 'red');
      final back = mapper.toEntity(mapper.toDto(v));
      expect(back.plate, 'ABC');
      expect(back.brandId, 'b1');
    });
    test('maps brand + model', () {
      expect(mapper.toBrand(const BrandDto(id: 'b', name: 'Toyota')).name, 'Toyota');
      expect(mapper.toModel(const VehicleModelDto(id: 'm', brandId: 'b', name: 'Corolla')).name, 'Corolla');
    });
  });

  group('VehicleNotifier', () {
    late _FakeVehicleRepository repo;

    ProviderContainer makeContainer() {
      repo = _FakeVehicleRepository();
      repo.store.add(const Vehicle(id: 'v1', plate: 'XYZ', brand: 'Toyota'));
      return ProviderContainer(overrides: [
        cachedSessionProvider.overrideWith((_) => session),
        vehicleRepositoryProvider.overrideWithValue(repo),
      ]);
    }

    test('loads vehicles + brands', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(vehicleProvider.notifier);
      await notifier.load();
      final state = container.read(vehicleProvider);
      expect(state.vehicles, hasLength(1));
      expect(state.brands, hasLength(2));
    });

    test('selectBrand loads models for that brand', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(vehicleProvider.notifier);
      await notifier.load();
      await notifier.selectBrand('b1');
      expect(container.read(vehicleProvider).models, hasLength(2));
      expect(repo.lastModelsBrandId, 'b1');
    });

    test('add creates and appends', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(vehicleProvider.notifier);
      await notifier.load();
      await notifier.add(const Vehicle(id: '', brandId: 'b1', modelId: 'm1', plate: 'NEW'));
      expect(container.read(vehicleProvider).vehicles, hasLength(2));
    });

    test('remove disables and drops from state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(vehicleProvider.notifier);
      await notifier.load();
      await notifier.remove('v1');
      expect(container.read(vehicleProvider).vehicles, isEmpty);
    });
  });
}