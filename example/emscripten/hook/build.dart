import 'dart:io';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_cmake/native_toolchain_cmake.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final sourceDir = Directory.current.uri.resolve('src/');

    // Get Emscripten toolchain file path
    // Use hardcoded path for testing since environment variables may not pass through to build hook
    final toolchainFile = '/Users/nickfisher/Documents/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake';

    final builder = CMakeBuilder.create(
      name: 'my_wasm_library',
      sourceDir: sourceDir,
      generator: Generator.ninja, // Use Ninja for reliable WebAssembly builds
      emscriptenArgs: EmscriptenBuilderArgs(
        toolchainFile: toolchainFile,
        emscriptenFlags: {
          // Remove global linker flags that interfere with CMake compiler testing
          // Function exports are handled in CMakeLists.txt instead
        },
        generateJs: true,
        generateHtml: false,
      ),
    );

    await builder.run(
      input: input,
      output: output,
    );

    // Find and add the WebAssembly assets
    await output.findAndAddCodeAssets(
      input,
      names: {'my_wasm_library': 'my_wasm_library.dart'},
    );
  });
}