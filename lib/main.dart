import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final markers = List.generate(
    1000,
    (i) => Marker(
      width: 52,
      height: 52,
      point: LatLng(39.5 + Random().nextDouble(), 116 + Random().nextDouble()),
      builder: (context) => const FlutterLogo(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(39.9, 116.4),
          maxZoom: 18,
          minZoom: 4,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          plugins: [MarkerClusterPlugin()],
        ),
        layers: [
          TileLayerOptions(
            tileProvider: const CachedTileProvider(),
            urlTemplate:
                'https://webrd01.is.autonavi.com/appmaptile?size=1&scale=1&style=7&x={x}&y={y}&z={z}',
          ),
          MarkerClusterLayerOptions(
            size: const Size(42, 42),
            maxClusterRadius: 200,
            disableClusteringAtZoom: 12,
            showPolygon: false,
            animationsOptions:
                const AnimationsOptions(zoom: Duration(milliseconds: 200)),
            markers: markers,
            builder: (context, markers) {
              return FloatingActionButton(
                child: Text('${markers.length}'),
                onPressed: null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(getTileUrl(coords, options));
  }
}
