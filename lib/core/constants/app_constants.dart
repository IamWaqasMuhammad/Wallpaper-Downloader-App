/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String apiKey = 'oU5O26m1h4g0x0O972u2gqK3Y33j7x9p7fW0f0I7u2Z6S6f8W0';
  static const String baseUrl = 'https://api.pexels.com/v1';
  
  // Pagination
  static const int perPage = 20;
  static const int initialPage = 1;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Search
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const String defaultSearchQuery = 'nature';
  
  // Categories
  static const List<String> popularCategories = [
    'Nature',
    'Abstract',
    'Animals',
    'Architecture',
    'Space',
    'Technology',
    'Cars',
    'Art',
  ];
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
