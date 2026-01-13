import 'package:postgres/postgres.dart';
import '../config/api_keys.dart';

/// Service class for PostgreSQL database operations
class DatabaseService {
  Connection? _connection;
  
  /// Connect to the PostgreSQL database
  Future<bool> connect() async {
    try {
      _connection = await Connection.open(
        Endpoint(
          host: dbHost,
          port: dbPort,
          database: dbName,
          username: dbUser,
          password: dbPassword,
        ),
        settings: ConnectionSettings(
          sslMode: SslMode.require,
        ),
      );
      print('✅ Connected to PostgreSQL database!');
      return true;
    } catch (e) {
      print('❌ Failed to connect to database: $e');
      return false;
    }
  }
  
  /// Close the database connection
  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    print('🔌 Database connection closed');
  }
  
  /// Check if connected
  bool get isConnected => _connection != null;
  
  /// Get all customers from the database
  Future<List<Map<String, dynamic>>> getCustomers() async {
    if (_connection == null) {
      throw Exception('Not connected to database. Call connect() first.');
    }
    
    try {
      final result = await _connection!.execute(
        'SELECT * FROM public.customers ORDER BY id',
      );
      
      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      print('❌ Error fetching customers: $e');
      rethrow;
    }
  }
  
  /// Get a single customer by ID
  Future<Map<String, dynamic>?> getCustomerById(int id) async {
    if (_connection == null) {
      throw Exception('Not connected to database. Call connect() first.');
    }
    
    try {
      final result = await _connection!.execute(
        Sql.named('SELECT * FROM public.customers WHERE id = @id'),
        parameters: {'id': id},
      );
      
      if (result.isEmpty) return null;
      return result.first.toColumnMap();
    } catch (e) {
      print('❌ Error fetching customer: $e');
      rethrow;
    }
  }
  
  /// Add a new customer
  Future<int> addCustomer({
    required String name,
    required String countries,
    required String contentCategory,
  }) async {
    if (_connection == null) {
      throw Exception('Not connected to database. Call connect() first.');
    }
    
    try {
      final result = await _connection!.execute(
        Sql.named('''
          INSERT INTO public.customers (name, countries, content_category)
          VALUES (@name, @countries, @category)
          RETURNING id
        '''),
        parameters: {
          'name': name,
          'countries': countries,
          'category': contentCategory,
        },
      );
      
      final newId = result.first.toColumnMap()['id'] as int;
      print('✅ Added new customer with ID: $newId');
      return newId;
    } catch (e) {
      print('❌ Error adding customer: $e');
      rethrow;
    }
  }
  
  /// Update a customer
  Future<bool> updateCustomer({
    required int id,
    String? name,
    String? countries,
    String? contentCategory,
  }) async {
    if (_connection == null) {
      throw Exception('Not connected to database. Call connect() first.');
    }
    
    try {
      final updates = <String>[];
      final params = <String, dynamic>{'id': id};
      
      if (name != null) {
        updates.add('name = @name');
        params['name'] = name;
      }
      if (countries != null) {
        updates.add('countries = @countries');
        params['countries'] = countries;
      }
      if (contentCategory != null) {
        updates.add('content_category = @category');
        params['category'] = contentCategory;
      }
      
      if (updates.isEmpty) return false;
      
      await _connection!.execute(
        Sql.named('UPDATE public.customers SET ${updates.join(', ')} WHERE id = @id'),
        parameters: params,
      );
      
      print('✅ Updated customer ID: $id');
      return true;
    } catch (e) {
      print('❌ Error updating customer: $e');
      rethrow;
    }
  }
  
  /// Delete a customer
  Future<bool> deleteCustomer(int id) async {
    if (_connection == null) {
      throw Exception('Not connected to database. Call connect() first.');
    }
    
    try {
      await _connection!.execute(
        Sql.named('DELETE FROM public.customers WHERE id = @id'),
        parameters: {'id': id},
      );
      
      print('✅ Deleted customer ID: $id');
      return true;
    } catch (e) {
      print('❌ Error deleting customer: $e');
      rethrow;
    }
  }
  
  /// Execute a raw SQL query
  Future<List<Map<String, dynamic>>> executeQuery(String sql) async {
    if (_connection == null) {
      throw Exception('Not connected to database. Call connect() first.');
    }
    
    try {
      final result = await _connection!.execute(sql);
      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      print('❌ Error executing query: $e');
      rethrow;
    }
  }
}

/// Singleton instance for easy access
final databaseService = DatabaseService();
