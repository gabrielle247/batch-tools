import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'video_model.dart';

class YtService {
  /// Determines download path based on Batch Tech folder structure
  Future<String> get _downloadPath async {
    final home = Platform.environment['HOME'];
    // Default to 'chill' downloads as requested
    final batchDir = Directory('$home/batch_tech/chill/downloads');
    
    if (await batchDir.exists()) {
      return batchDir.path;
    }
    
    // Fallback if folders are missing
    final docDir = await getApplicationDocumentsDirectory();
    return docDir.path;
  }

  /// Searches YouTube or fetches Metadata for a direct Link
  Future<List<VideoModel>> searchOrFetch(String query) async {
    List<String> args = [];

    if (query.startsWith('http')) {
      // Direct Link Mode
      args = [
        query,
        '--dump-json',
        '--skip-download',
        '--flat-playlist'
      ];
    } else {
      // Search Mode
      args = [
        'ytsearch20:$query',
        '--dump-json',
        '--skip-download',
        '--flat-playlist'
      ];
    }

    try {
      // Attempt to run yt-dlp. Assumes it is in PATH.
      final result = await Process.run('yt-dlp', args);
      
      if (result.exitCode != 0) {
        return [];
      }

      final List<VideoModel> videos = [];
      final lines = LineSplitter.split(result.stdout.toString());
      
      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          try {
            final json = jsonDecode(line);
            videos.add(VideoModel.fromJson(json));
          } catch (e) {
            // Skip malformed lines silently
          }
        }
      }
      return videos;
    } catch (e) {
      print('Execution error: $e');
      return [];
    }
  }

  /// Downloads the video using Batch Tech v3 logic (1080p Cap, Series support)
  Future<void> downloadVideo(VideoModel video, Function(String) onLog) async {
    final savePath = await _downloadPath;
    
    // Greyway Quality Standard: 1080p Limit
    final qualityArgs = [
      '-f', 'bv*[height<=1080]+ba/b[height<=1080] / best',
      '--merge-output-format', 'mp4',
    ];

    List<String> finalArgs = [video.url, ...qualityArgs];

    // Smart Folder Logic for TikTok Series and Playlists
    if (video.url.contains('tiktok')) {
      final safeTitle = video.title.replaceAll(RegExp(r'[^a-zA-Z0-9_ -]'), '');
      final seriesDir = Directory('$savePath/$safeTitle');
      if (!await seriesDir.exists()) {
        await seriesDir.create(recursive: true);
      }
      
      // Use upload_date for sorting series parts
      finalArgs = [
        video.url,
        '--yes-playlist',
        '-o', '${seriesDir.path}/%(upload_date)s_%(title)s.%(ext)s'
      ];
    } else if (video.url.contains('list=')) {
      final safeTitle = video.title.replaceAll(RegExp(r'[^a-zA-Z0-9_ -]'), '');
      final courseDir = Directory('$savePath/$safeTitle');
      if (!await courseDir.exists()) {
        await courseDir.create(recursive: true);
      }

      // Use playlist_index for sorting courses
      finalArgs = [
        video.url,
        ...qualityArgs,
        '-o', '${courseDir.path}/%(playlist_index)s_%(title)s.%(ext)s'
      ];
    } else {
      // Single Video
      finalArgs.addAll(['-o', '$savePath/%(title)s.%(ext)s']);
    }

    try {
      final process = await Process.start('yt-dlp', finalArgs);
      
      process.stdout.transform(utf8.decoder).listen((data) {
        onLog(data.trim());
      });
      
      process.stderr.transform(utf8.decoder).listen((data) {
        onLog('ERR: ${data.trim()}');
      });

      final exitCode = await process.exitCode;
      if (exitCode == 0) {
        onLog('✅ COMPLETE');
      } else {
        onLog('❌ FAILED (Code $exitCode)');
      }
    } catch (e) {
      onLog('❌ SYS ERR: $e');
    }
  }
}
