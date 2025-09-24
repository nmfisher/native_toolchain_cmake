import 'dart:io';

void main() async {
  print('Testing WebAssembly compilation with Emscripten...');

  // Clean any existing CMake cache first
  print('Cleaning CMake cache...');
  await Process.run('find', ['.', '-name', 'CMakeCache.txt', '-delete'], runInShell: true);
  await Process.run('find', ['.', '-name', 'CMakeFiles', '-type', 'd', '-exec', 'rm', '-rf', '{}', '+'], runInShell: true);

  // Run the native assets build
  print('Running native assets build...');
  final result = await Process.run('dart', ['run'], runInShell: true);

  print('\nBuild output:');
  if (result.stdout.isNotEmpty) {
    print(result.stdout);
  }
  if (result.stderr.isNotEmpty) {
    print('Build errors:');
    print(result.stderr);
  }

  print('Build completed with exit code: ${result.exitCode}');

  // Look for WebAssembly files in common output locations
  final locations = [
    '.',
    '.dart_tool/native_assets',
    'build',
  ];

  print('\nSearching for generated WebAssembly files...');
  bool foundWasm = false;
  bool foundJs = false;

  for (final location in locations) {
    final dir = Directory(location);
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final name = entity.path.split('/').last;
          if (name.endsWith('.wasm')) {
            print('Found WebAssembly file: ${entity.path}');
            final size = await entity.length();
            print('  Size: $size bytes');
            foundWasm = true;
          } else if (name.endsWith('.js') && name.contains('wasm')) {
            print('Found JavaScript file: ${entity.path}');
            foundJs = true;
          }
        }
      }
    }
  }

  print('\nSummary:');
  print('WebAssembly build ${result.exitCode == 0 ? 'SUCCESS' : 'FAILED'}');
  print('WASM file generated: ${foundWasm ? 'YES' : 'NO'}');
  print('JS file generated: ${foundJs ? 'YES' : 'NO'}');
}