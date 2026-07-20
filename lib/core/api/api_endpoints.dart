class ApiEndpoints {
  // ==========================
  // User
  // ==========================
  static const String register = "/users/register";
  static const String login = "/users/login";

  // ==========================
  // Users
  // ==========================

  // Get all users
  static const String users = "/users/";

  // Get logged-in user by ID
  static String getUser(int id) => "/users/$id";

  // ==========================
  // Profile
  // ==========================
  static const String profiles = "/profile/";
  static const String createProfile = "/profile/";

  // Dynamic Endpoints
  static String getProfile(String profileId) => "/profile/$profileId";
  static String updateProfile(String profileId) => "/profile/$profileId";
  static String deleteProfile(String profileId) => "/profile/$profileId";

  // ==========================
  // Chat
  // ==========================
  static const String createChat = "/chat/";

  // Dynamic Endpoints
  static String getChat(String chatId) => "/chat/$chatId";
  static String deleteChat(String chatId) => "/chat/$chatId";
}