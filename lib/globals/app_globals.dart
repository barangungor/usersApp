class AppGlobals {
  static const apiUrl = 'https://6337eb525327df4c43d9eea3.mockapi.io/user';
  static updateUrl(id) => '$apiUrl/$id';
  static deleteUrl(id) => '$apiUrl/$id';
}
