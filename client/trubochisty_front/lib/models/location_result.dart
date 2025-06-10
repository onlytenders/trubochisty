/// A Result class for handling success/failure states in location operations
/// Follows the Result pattern for better error handling
class LocationResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const LocationResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  /// Creates a successful result with data
  factory LocationResult.success(T data) {
    return LocationResult._(
      data: data,
      isSuccess: true,
    );
  }

  /// Creates a failure result with error message
  factory LocationResult.failure(String error) {
    return LocationResult._(
      error: error,
      isSuccess: false,
    );
  }

  /// Checks if the result is a failure
  bool get isFailure => !isSuccess;

  /// Gets the data if successful, throws if failure
  T get requireData {
    if (isFailure) {
      throw StateError('Attempted to get data from failed result: $error');
    }
    return data!;
  }

  /// Gets the error if failure, throws if successful
  String get requireError {
    if (isSuccess) {
      throw StateError('Attempted to get error from successful result');
    }
    return error!;
  }

  @override
  String toString() {
    return isSuccess 
        ? 'LocationResult.success($data)'
        : 'LocationResult.failure($error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationResult<T> &&
        other.data == data &&
        other.error == error &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode => Object.hash(data, error, isSuccess);
} 