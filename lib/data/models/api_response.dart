

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.error,
    required this.isSuccess,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse(
      data: data,
      error: null,
      isSuccess: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.failure(String error, {int? statusCode}) {
    return ApiResponse(
      data: null,
      error: error,
      isSuccess: false,
      statusCode: statusCode,
    );
  }
}
