/// Reusable Google Maps address picker.
///
/// Self-contained: manages its own Places autocomplete suggestions, map camera,
/// and reverse-geocode-on-confirm, calling back with the resolved
/// `(address, lat, lng)`. Used by the registration form (bottom sheet) and the
/// assistance flow (inline step).
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/loading.dart';
import '../../domain/entities/places_entities.dart';
import '../providers/places_providers.dart';

typedef AddressPickedCallback = void Function(
  String address,
  double lat,
  double lng,
);

class AddressMapPicker extends ConsumerStatefulWidget {
  const AddressMapPicker({
    required this.onPicked,
    this.initialAddress = '',
    this.initialLat,
    this.initialLng,
    this.confirmLabel = 'Confirmar ubicación',
    super.key,
  });

  final AddressPickedCallback onPicked;
  final String initialAddress;
  final double? initialLat;
  final double? initialLng;
  final String confirmLabel;

  @override
  ConsumerState<AddressMapPicker> createState() => _AddressMapPickerState();
}

class _AddressMapPickerState extends ConsumerState<AddressMapPicker> {
  static const _default = LatLng(4.624335, -74.063644);

  late final TextEditingController _searchController;
  final _debouncer = Debouncer(const Duration(milliseconds: 350));
  GoogleMapController? _mapController;
  LatLng? _target;
  LatLng? _lastCameraTarget;
  bool _animating = false;
  bool _loading = false;
  String _address = '';
  List<PlaceSuggestion> _suggestions = const [];

  @override
  void initState() {
    super.initState();
    _address = widget.initialAddress;
    _searchController = TextEditingController(text: widget.initialAddress);
    if (widget.initialLat != null && widget.initialLng != null) {
      _target = LatLng(widget.initialLat!, widget.initialLng!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _runAutocomplete(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _suggestions = const []);
      return;
    }
    final result = await ref
        .read(autocompletePlacesUseCaseProvider)
        .call(query);
    result.fold(
      onSuccess: (suggestions) =>
          setState(() => _suggestions = suggestions),
      onFailure: (failure) {
        setState(() => _suggestions = const []);
        _toast('No se pudieron buscar direcciones: ${failure.message}');
      },
    );
  }

  Future<void> _selectSuggestion(PlaceSuggestion suggestion) async {
    _searchController.text = suggestion.description;
    setState(() {
      _suggestions = const [];
      _loading = true;
    });
    final result = await ref
        .read(placeDetailsUseCaseProvider)
        .call(suggestion.placeId);
    result.fold(
      onSuccess: (place) {
        final lat = place.lat;
        final lng = place.lng;
        if (lat != null && lng != null) {
          _target = LatLng(lat, lng);
          _animateTo(lat, lng);
        }
        setState(() {
          _address = place.formattedAddress ?? suggestion.description;
          _loading = false;
        });
      },
      onFailure: (_) => setState(() => _loading = false),
    );
  }

  Future<void> _animateTo(double lat, double lng) async {
    _animating = true;
    await _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
    _animating = false;
  }

  Future<void> _confirm() async {
    final target = _target ?? _lastCameraTarget;
    if (target == null) return;
    setState(() => _loading = true);
    final result = await ref
        .read(reverseGeocodeUseCaseProvider)
        .call(target.latitude, target.longitude);
    String address = _address;
    result.fold(
      onSuccess: (reversed) {
        address = reversed;
        _address = reversed;
      },
      onFailure: (failure) =>
          _toast('No se pudo obtener la dirección: ${failure.message}'),
    );
    setState(() => _loading = false);
    widget.onPicked(address, target.latitude, target.longitude);
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final initial = (_target != null) ? _target! : _default;
    return LoadingOverlay(
      isLoading: _loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar dirección',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _debouncer.run(
                () => _runAutocomplete(value),
              ),
            ),
          ),
          if (_suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final s in _suggestions)
                      ListTile(
                        title: Text(s.description),
                        onTap: () => _selectSuggestion(s),
                      ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: initial,
                        zoom: 14,
                      ),
                      myLocationButtonEnabled: false,
                      // Let the map consume pan/zoom gestures even when hosted
                      // inside a bottom sheet / column that would otherwise
                      // steal vertical drags.
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      onMapCreated: (controller) =>
                          _mapController = controller,
                      onCameraMove: (pos) => _lastCameraTarget = pos.target,
                      onCameraIdle: () {
                        final t = _lastCameraTarget;
                        if (t != null && !_animating) _target = t;
                      },
                    ),
                    const Center(
                      child: Icon(
                        Icons.location_pin,
                        size: 44,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_address.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _address,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton(
              onPressed: _loading ? null : _confirm,
              child: Text(widget.confirmLabel),
            ),
          ),
        ],
      ),
    );
  }
}