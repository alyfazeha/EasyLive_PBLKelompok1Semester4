class MockDatabase {

  static Map<String, Map<String, String>> registeredUsers = {
    "user@mail.com": {"password": "123", "nama": "user"},
  };

  static void addUser(String email, String password, String nama, String phone) {
    registeredUsers[email.toLowerCase().trim()] = {
      "password": password,
      "nama": nama,
      "phone": phone,
    };
  }

  static bool checkLogin(String email, String password) {
    String cleanEmail = email.toLowerCase().trim();
    if (registeredUsers.containsKey(cleanEmail)) {
      return registeredUsers[cleanEmail]!['password'] == password;
    }
    return false;
  }
}