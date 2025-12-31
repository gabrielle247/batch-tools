import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'video_model.dart';
import 'yt_service.dart';

void main() {
  runApp(const BatchGuiApp());
}

class BatchGuiApp extends StatelessWidget {
  const BatchGuiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batch Tech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Greyway Dark
        primaryColor: const Color(0xFF00AAFF), // Greyway Blue
        useMaterial3: true,
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00AAFF),
          secondary: Color(0xFF00AAFF),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _consoleScroll = ScrollController();
  final YtService _ytService = YtService();
  
  List<VideoModel> _results = [];
  final List<String> _consoleLogs = [];
  
  bool _isLoading = false;
  bool _showConsole = false;
  String _statusMessage = "System Online.";

  void _addLog(String message) {
    if (message.isEmpty) return;
    setState(() {
      _consoleLogs.add(message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_consoleScroll.hasClients) {
        _consoleScroll.jumpTo(_consoleScroll.position.maxScrollExtent);
      }
    });
  }

  Future<void> _handleSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Scanning Grid...";
      _results = [];
      _consoleLogs.clear();
    });

    _addLog("> Fetching metadata for: $query");
    
    final videos = await _ytService.searchOrFetch(query);

    setState(() {
      _results = videos;
      _isLoading = false;
      _statusMessage = "Found ${videos.length} items.";
    });
    
    _addLog("> Scan complete. ${videos.length} found.");
  }

  void _download(VideoModel video) {
    setState(() {
      video.isDownloading = true;
      _showConsole = true; 
    });

    _addLog("> Initiating download protocol for: ${video.title}");

    _ytService.downloadVideo(video, (log) {
      _addLog(log);
    }).then((_) {
      if (mounted) {
        setState(() {
          video.isDownloading = false;
          video.isCompleted = true;
          _statusMessage = "Saved: ${video.title}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Color(0xFF00AAFF), size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _handleSearch(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search YouTube or Paste URL...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF121212),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF00AAFF)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _isLoading ? null : _handleSearch,
                  icon: _isLoading 
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.play_arrow, color: Color(0xFF00AAFF)),
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _results.isEmpty && !_isLoading
              ? Center(child: Text("Batch Tech v3.3", style: TextStyle(color: Colors.grey[800])))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _results.length,
                  itemBuilder: (context, index) => _buildCard(_results[index]),
                ),
          ),

          // Console
          if (_showConsole)
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                controller: _consoleScroll,
                itemCount: _consoleLogs.length,
                itemBuilder: (context, index) {
                  return Text(
                    _consoleLogs[index],
                    style: TextStyle(
                      color: _consoleLogs[index].contains('ERR') ? Colors.red : const Color(0xFF00AAFF),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  );
                },
              ),
            ),

          // Status Bar
          InkWell(
            onTap: () => setState(() => _showConsole = !_showConsole),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              color: const Color(0xFF00AAFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_statusMessage.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                  Icon(_showConsole ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 16, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(VideoModel video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: video.isCompleted ? Colors.green.withAlpha(200) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: video.thumbnailUrl,
              fit: BoxFit.cover,
              imageErrorBuilder: (c, o, s) => Container(color: Colors.grey[900]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  video.channel,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _download(video),
            icon: video.isDownloading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(video.isCompleted ? Icons.check : Icons.download, color: const Color(0xFF00AAFF)),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
