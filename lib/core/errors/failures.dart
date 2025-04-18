// Clase base para manejar errores en la aplicación
abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Error relacionado con el almacenamiento
class StorageFailure extends Failure {
  const StorageFailure(String message) : super(message);
}

// Error relacionado con la reproducción de audio
class AudioFailure extends Failure {
  const AudioFailure(String message) : super(message);
}