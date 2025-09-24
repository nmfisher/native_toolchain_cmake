# native_toolchain_cmake

A library to invoke CMake for Dart Native Assets.

## Status: Experimental

This library is experimental and may change without warning, use with caution!

## Example

Refer to [example](https://github.com/rainyl/native_toolchain_cmake/tree/main/example)

## WebAssembly Support

native_toolchain_cmake supports building WebAssembly modules using the Emscripten toolchain.

### Prerequisites

1. Install and activate the Emscripten SDK:
   ```bash
   git clone https://github.com/emscripten-core/emsdk.git
   cd emsdk
   ./emsdk install latest
   ./emsdk activate latest
   source ./emsdk_env.sh
   ```

2. Ensure the `EMSDK` environment variable is set.

### Usage

```dart
import 'dart:io';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_cmake/native_toolchain_cmake.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final emsdk = Platform.environment['EMSDK'];
    final toolchainFile = '$emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake';

    final builder = CMakeBuilder.create(
      name: 'my_library',
      sourceDir: Directory.current.uri.resolve('src/'),
      emscriptenArgs: EmscriptenBuilderArgs(
        toolchainFile: toolchainFile,
        emscriptenFlags: {
          'CMAKE_CXX_FLAGS': '-s WASM=1',
        },
      ),
    );

    await builder.run(input: input, output: output);
    await output.findAndAddCodeAssets(input, names: {'my_library': 'my_library.dart'});
  });
}
```

### Output

The build process will generate:
- `my_library.wasm` - The WebAssembly module
- `my_library.js` - JavaScript loading code (if `generateJs: true`)

Place these files in your web application's assets directory (e.g., `web/assets/`).

See [example/emscripten](https://github.com/rainyl/native_toolchain_cmake/tree/main/example/emscripten) for a complete working example.

## Acknowledgements

- [native_toolchain_c](https://pub.dev/packages/native_toolchain_c)

## License

Apache-2.0 License
