import 'package:dio/dio.dart';
import 'package:dio_request/models/product.dart';

class ProductService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      responseType: ResponseType.json));

  // Update a product
  Future<Response> updateProduct(
      String id, Map<String, dynamic> product) async {
    try {
      return await _dio.put('/products/$id', data: product);
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // Delete a product
  Future<Response> deleteProduct(String id) async {
    try {
      return await _dio.delete('/products/$id');
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // List products
  Future<List<Product>> listProducts() async {
    try {
      final response = await _dio.get('/products');
      List<Product> products = (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return products;
    } on DioException {
      throw Exception('Failed to load products');
    }
  }

  // Upload an image
  Future<Response> uploadImage(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'upload.jpg'),
      });
      return await _dio.post('/upload', data: formData);
    } on DioException catch (e) {
      return e.response!;
    }
  }
}
