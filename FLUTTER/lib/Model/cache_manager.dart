import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  late Directory _cacheDirectory;
  late Reference _cacheUpdaterSource;
  late int _nMinutesCacheTimeout;
  late Map<String, Uint8List> _inMemoryCache;

  CacheManager({required Reference cacheUpdaterSource, required int nMinutesCacheTimeout}) {
    getApplicationDocumentsDirectory().then((value) async {
      _cacheDirectory = value;
      _inMemoryCache = {};
      
      await _cacheDirectory.list(followLinks: false).forEach((element) {
        _inMemoryCache[element.path.split("/").last] = Uint8List(0);
      });
    });
    _cacheUpdaterSource = cacheUpdaterSource;
    _nMinutesCacheTimeout = nMinutesCacheTimeout;
  }

  Future add({required Uint8List data, required String name}) async {
    _inMemoryCache[name] = data;
    File toSave = File("${_cacheDirectory.path}/$name");
    
    await toSave.writeAsBytes(data);
  }

  Future<Uint8List> get({required String name}) async {
    if (_inMemoryCache.containsKey(name)) {
      File file = File("${_cacheDirectory.path}/$name");
      
      if (_inMemoryCache[name]!.isEmpty){
        _inMemoryCache[name] = file.readAsBytesSync();
      }

      if (file.lastModifiedSync().difference(DateTime.now()) > Duration(minutes: _nMinutesCacheTimeout)){
        add(data: await _loadFromStorage(name: name), name: name);
      }

    }
    else 
    {
      add(data: await _loadFromStorage(name: name), name: name);
    }

    return _inMemoryCache[name]!;
  }

  FutureOr<Uint8List> _loadFromStorage({required String name}) {
    return _cacheUpdaterSource.child(name).getData().then((value) {
      if (value != null) {
        return value;    
      } else {
        return Uint8List(0);
      }
    });
  }
}