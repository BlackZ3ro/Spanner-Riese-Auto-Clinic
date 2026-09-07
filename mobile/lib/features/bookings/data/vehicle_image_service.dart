import 'dart:convert';
import 'package:http/http.dart' as http;

class VehicleImageService {
  
  Future<String?> findImageUrl(String query) async {
    final result = await _search(query);
    if (result != null) return result;

    final withoutYear = query.replaceAll(RegExp(r'\s+\d{4}$'), '').trim();
    if (withoutYear != query && withoutYear.isNotEmpty) {
      return _search(withoutYear);
    }
    return null;
  }
  
  
  
  Future<String?> _search(String query) async{
    final uri = Uri.https('commons.wikimedia.org', '/w/api.php',{
      'action': 'query',
      'generator' : 'search',
      'gsrsearch' : query,
      'gsrnamespace' : '6',
      'gsrlimit' : '1',
      'prop' : 'imageinfo',
      'iiprop' : 'url',
      'format' : 'json',
      'origin' : '*',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) return null; 

    final data = jsonDecode(response.body) as Map<String,dynamic>;
    final pages = data['query']?['pages'] as Map<String,dynamic>?;
    if (pages == null || pages.isEmpty) return null;

    final firstPage = pages.values.first as Map<String, dynamic>;
    final imageInfo = firstPage['imageinfo'] as List?;
    if (imageInfo == null || imageInfo.isEmpty) return null;

    return imageInfo.first['url'] as String?;
  }
}