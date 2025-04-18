import 'dart:io';

void main() {
  final directories = [
    'lib/core/constants',
    'lib/core/errors',
    'lib/core/network',
    'lib/core/platform',
    'lib/core/utils',
    'lib/core/widgets',
    'lib/data/datasources',
    'lib/data/models',
    'lib/data/repositories',
    'lib/domain/entities',
    'lib/domain/repositories',
    'lib/domain/usecases',
    'lib/presentation/blocs',
    'lib/presentation/pages',
    'lib/presentation/widgets',
  ];

  for (var dir in directories) {
    Directory(dir).createSync(recursive: true);
  }

  // Crear los archivos de exportación
  File('lib/data/data.dart').createSync();
  File('lib/domain/domain.dart').createSync();
  File('lib/presentation/presentation.dart').createSync();

  print('Estructura de carpetas creada exitosamente!');
}
