import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/supplier.dart';
import '../models/pallet.dart';
import '../models/warehouse.dart';
import '../models/warehouse_object.dart';
import '../models/product_instance.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://9038-194-69-103-34.ngrok-free.app/api'});

  // Products
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id/'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }

  // Suppliers
  Future<List<Supplier>> getSuppliers() async {
    final response = await http.get(Uri.parse('$baseUrl/suppliers/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Supplier.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }

  Future<Supplier> getSupplier(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/suppliers/$id/'));
    if (response.statusCode == 200) {
      return Supplier.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  Future<Supplier> createSupplier(Supplier supplier) async {
    final response = await http.post(
      Uri.parse('$baseUrl/suppliers/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(supplier.toJson()),
    );
    if (response.statusCode == 201) {
      return Supplier.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create supplier');
    }
  }

  Future<Supplier> updateSupplier(Supplier supplier) async {
    final response = await http.put(
      Uri.parse('$baseUrl/suppliers/${supplier.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(supplier.toJson()),
    );
    if (response.statusCode == 200) {
      return Supplier.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update supplier');
    }
  }

  Future<void> deleteSupplier(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/suppliers/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete supplier');
    }
  }

  // Pallets
  Future<List<Pallet>> getPallets() async {
    final response = await http.get(Uri.parse('$baseUrl/pallets/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Pallet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pallets');
    }
  }

  Future<Pallet> getPallet(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pallets/$id/'));
    if (response.statusCode == 200) {
      return Pallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load pallet');
    }
  }

  Future<Pallet> createPallet(Pallet pallet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pallets/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pallet.toJson()),
    );
    if (response.statusCode == 201) {
      return Pallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create pallet');
    }
  }

  Future<Pallet> updatePallet(Pallet pallet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pallets/${pallet.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pallet.toJson()),
    );
    if (response.statusCode == 200) {
      return Pallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update pallet');
    }
  }

  Future<void> deletePallet(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pallets/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete pallet');
    }
  }

  // Warehouses
  Future<List<Warehouse>> getWarehouses() async {
    final response = await http.get(Uri.parse('$baseUrl/warehouses/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Warehouse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load warehouses');
    }
  }

  Future<Warehouse> getWarehouse(String id) async {
    Map<String, String> headers = {'ngrok-skip-browser-warning': 'flutter_app'};
    final response = await http.get(Uri.parse('$baseUrl/warehouses/$id/'));
    print(response.body);
    if (response.statusCode == 200) {
      return Warehouse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load warehouse');
    }
  }

  Future<Warehouse> createWarehouse(Warehouse warehouse) async {
    final response = await http.post(
      Uri.parse('$baseUrl/warehouses/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(warehouse.toJson()),
    );
    if (response.statusCode == 201) {
      return Warehouse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create warehouse');
    }
  }

  Future<Warehouse> updateWarehouse(Warehouse warehouse) async {
    final response = await http.put(
      Uri.parse('$baseUrl/warehouses/${warehouse.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(warehouse.toJson()),
    );
    if (response.statusCode == 200) {
      return Warehouse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update warehouse');
    }
  }

  Future<void> deleteWarehouse(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/warehouses/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete warehouse');
    }
  }

  // Warehouse Objects
  Future<List<WarehouseObject>> getWarehouseObjects() async {
    final response = await http.get(Uri.parse('$baseUrl/warehouse-objects/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => WarehouseObject.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load warehouse objects');
    }
  }

  Future<WarehouseObject> getWarehouseObject(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/warehouse-objects/$id/'));
    if (response.statusCode == 200) {
      return WarehouseObject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load warehouse object');
    }
  }

  Future<WarehouseObject> createWarehouseObject(WarehouseObject object) async {
    final response = await http.post(
      Uri.parse('$baseUrl/warehouse-objects/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(object.toJson()),
    );
    if (response.statusCode == 201) {
      return WarehouseObject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create warehouse object');
    }
  }

  Future<WarehouseObject> updateWarehouseObject(WarehouseObject object) async {
    final response = await http.put(
      Uri.parse('$baseUrl/warehouse-objects/${object.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(object.toJson()),
    );
    if (response.statusCode == 200) {
      return WarehouseObject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update warehouse object');
    }
  }

  Future<void> deleteWarehouseObject(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/warehouse-objects/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete warehouse object');
    }
  }

  // Product Instances
  Future<List<ProductInstance>> getProductInstances() async {
    final response = await http.get(Uri.parse('\$baseUrl/product-instances/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => ProductInstance.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load product instances');
    }
  }

  Future<ProductInstance> getProductInstance(String id) async {
    final response = await http.get(Uri.parse('\$baseUrl/product-instances/\$id/'));
    if (response.statusCode == 200) {
      return ProductInstance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product instance');
    }
  }

  Future<ProductInstance> createProductInstance(ProductInstance instance) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/product-instances/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(instance.toJson()),
    );
    if (response.statusCode == 201) {
      return ProductInstance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product instance');
    }
  }

  Future<ProductInstance> updateProductInstance(ProductInstance instance) async {
    final response = await http.put(
      Uri.parse('\$baseUrl/product-instances/\${instance.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(instance.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductInstance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product instance');
    }
  }

  Future<void> deleteProductInstance(String id) async {
    final response = await http.delete(Uri.parse('\$baseUrl/product-instances/\$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product instance');
    }
  }
}