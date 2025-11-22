import '../models/product.dart';
import 'http_service.dart';

class MySQLService {
  // Initialize database (create table)
  static Future<void> initializeDatabase() async {
    try {
      await HttpService.get('api.php?init=1');
      print('✅ MySQL database initialized successfully');
    } catch (e) {
      print('❌ MySQL initialization error: $e');
      throw e;
    }
  }

  // Get all products
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await HttpService.get('api.php');

      // ✅ DEBUG: Print response untuk troubleshooting
      print('📦 Raw API Response: $response');

      // ✅ Check if 'data' key exists and is a List
      if (response.containsKey('data') && response['data'] is List) {
        final List<dynamic> productsData = response['data'];

        // ✅ Convert each item safely
        final List<Product> products = [];
        for (var item in productsData) {
          try {
            print('🔧 Parsing product item: $item');
            final product = Product.fromJson(item);
            products.add(product);
          } catch (e) {
            print('❌ Error parsing product item: $item');
            print('❌ Error details: $e');
          }
        }

        print('✅ Successfully parsed ${products.length} products');
        return products;
      } else {
        print('❌ Invalid response format: $response');
        throw 'Invalid response format: missing data array';
      }
    } catch (e) {
      print('❌ Error getting products: $e');
      throw e;
    }
  }

  // Get product by ID
  static Future<Product?> getProductById(int id) async {
    try {
      final response = await HttpService.get('api.php?id=$id');
      return Product.fromJson(response);
    } catch (e) {
      print('❌ Error getting product by ID: $e');
      return null;
    }
  }

  // Insert product
  static Future<int> insertProduct(Product product) async {
    try {
      final response = await HttpService.post('api.php', product.toJson());
      return _parseInt(response['id']);
    } catch (e) {
      print('❌ Error inserting product: $e');
      throw e;
    }
  }

  // Update product
  static Future<bool> updateProduct(Product product) async {
    try {
      await HttpService.put('api.php', product.toJson());
      return true;
    } catch (e) {
      print('❌ Error updating product: $e');
      throw e;
    }
  }

  // Delete product
  static Future<bool> deleteProduct(int id) async {
    try {
      await HttpService.delete('api.php', {'id': id});
      return true;
    } catch (e) {
      print('❌ Error deleting product: $e');
      throw e;
    }
  }

  // Check if service is available
  static Future<bool> checkConnection() async {
    try {
      await HttpService.get('api.php');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Debug method
  static Future<void> debugProducts() async {
    try {
      final response = await HttpService.get('api.php');
      print('🔍 DEBUG Response:');
      print('🔍 Full response: $response');

      if (response.containsKey('data')) {
        final data = response['data'];
        print('🔍 Data type: ${data.runtimeType}');

        if (data is List && data.isNotEmpty) {
          print('🔍 First item: ${data.first}');
          print(
              '🔍 First item price: ${data.first['price']} (type: ${data.first['price'].runtimeType})');
          print(
              '🔍 First item quantity: ${data.first['quantity']} (type: ${data.first['quantity'].runtimeType})');
        }
      }
    } catch (e) {
      print('❌ Debug error: $e');
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
