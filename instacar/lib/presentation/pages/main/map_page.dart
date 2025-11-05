import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:instacar/core/services/map_service.dart';
import 'dart:ui_web' as ui_web;
import 'package:go_router/go_router.dart';
import 'package:instacar/core/services/ride_service.dart';
import 'package:instacar/core/models/RideModel.dart';
import 'package:instacar/presentation/widgets/navbar.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final String _viewType;
  html.IFrameElement? _iframe;
  bool _mapReady = false; // reserved for future use (e.g., disabling actions until ready)
  bool _loading = true;
  bool _showRides = true;
  
  void _postMessage(dynamic message) {
    final win = _iframe?.contentWindow;
    if (win != null) {
      win.postMessage(message, '*');
    }
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _setupIframe();
      // Ouvir mensagens do iframe (web/map.html)
      html.window.onMessage.listen((event) async {
        final data = event.data;
        if (data is Map && data['type'] == 'openRide') {
          final rideId = data['rideId']?.toString();
          if (rideId != null && mounted) {
            // Abrir modal bottom sheet com detalhes
            if (!mounted) return;
            // ignore: use_build_context_synchronously
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => _RideBottomSheet(rideId: rideId),
            );
          }
        } else if (data is Map && data['type'] == 'requestRides') {
          // Reenvia a lista atual de caronas para o mapa
          try {
            final rides = await MapService.getAvailableRides();
            _postMessage({'type': 'updateRides', 'rides': rides});
          } catch (_) {}
        }
      });
    } else {
      _loading = false;
    }
  }

  void _setupIframe() {
    _viewType = 'instacar-map-${DateTime.now().millisecondsSinceEpoch}';

    _iframe = html.IFrameElement()
      ..src = 'map.html'
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      return _iframe!;
    });

    _iframe!.onLoad.listen((_) async {
      setState(() {
        _mapReady = true;
      });
      await _loadRidesAndCenterOnUser();
    });
  }

  Future<void> _loadRidesAndCenterOnUser() async {
    try {
      setState(() {
        _loading = true;
      });
      final rides = await MapService.getAvailableRides();
      // Always send data updates; visibility handled separately
      _postMessage({'type': 'updateRides', 'rides': rides});
      // Apply visibility state without clearing data
      _postMessage(_showRides ? 'showRides' : 'hideRides');
      // Desenhar/centralizar no usuário sem afetar caronas
      MapService.centerOnUser();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _centerOnUser() async {
    MapService.centerOnUser();
  }

  Future<void> _toggleShowRides() async {
    setState(() {
      _showRides = !_showRides;
    });
    // Toggle visibility without reloading data
    _postMessage(_showRides ? 'showRides' : 'hideRides');
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: const Center(
          child: Text('Mapa disponível apenas no Web.'),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          TopNavbar(
            onSearchChanged: (_) {},
            showFilter: false,
            showSearch: false,
            showRequestsButton: true,
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _iframe == null
                      ? const SizedBox.shrink()
                      : HtmlElementView(viewType: _viewType),
                ),
                // Ações do mapa no canto superior direito
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _MapActionButton(
                        tooltip: _showRides ? 'Ocultar caronas' : 'Mostrar caronas',
                        icon: _showRides ? Icons.visibility_off : Icons.directions_car,
                        onPressed: _toggleShowRides,
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(width: 4),
                      _MapActionButton(
                        tooltip: 'Minha localização',
                        icon: Icons.my_location,
                        onPressed: _centerOnUser,
                      ),
                      const SizedBox(width: 8),
                      _MapActionButton(
                        tooltip: 'Atualizar',
                        icon: Icons.refresh,
                        onPressed: _loadRidesAndCenterOnUser,
                      ),
                    ],
                  ),
                ),
                if (_loading)
                  const Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
      floatingActionButton: null,
    );
  }
}


class _RideBottomSheet extends StatefulWidget {
  final String rideId;
  const _RideBottomSheet({required this.rideId});

  @override
  State<_RideBottomSheet> createState() => _RideBottomSheetState();
}

class _RideBottomSheetState extends State<_RideBottomSheet> {
  late Future<RideModel> _future;

  @override
  void initState() {
    super.initState();
    _future = RideService().fetchRideById(widget.rideId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return FutureBuilder<RideModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Erro ao carregar carona', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(snapshot.error.toString()),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Fechar'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final ride = snapshot.data!;
                final remainingSpots = (ride.totalSpots - ride.takenSpots).clamp(0, ride.totalSpots);
                return Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Detalhes da carona',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${ride.from} → ${ride.to}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 6),
                        Text('Motorista: ${ride.name}'),
                        const SizedBox(height: 6),
                        if (ride.date.isNotEmpty) Text('Horário/Data: ${ride.date}'),
                        const SizedBox(height: 6),
                        Text('Vagas: $remainingSpots de ${ride.totalSpots}'),
                        const SizedBox(height: 6),
                        Text('Veículo: ${ride.model} • ${ride.color} • ${ride.plate}'),
                        if (ride.observation.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Text('Observações:', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(ride.observation),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.push('/ride-details/${ride.id}');
                                },
                                icon: const Icon(Icons.open_in_new),
                                label: const Text('Ver página completa'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(48),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class _MapActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  const _MapActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
