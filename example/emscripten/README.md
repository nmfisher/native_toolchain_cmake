# Emscripten WebAssembly Example

This example demonstrates how to use native_toolchain_cmake to build WebAssembly modules using the Emscripten toolchain.

## Prerequisites

1. Install and activate the Emscripten SDK:
   ```bash
   git clone https://github.com/emscripten-core/emsdk.git
   cd emsdk
   ./emsdk install latest
   ./emsdk activate latest
   source ./emsdk_env.sh
   ```

2. Ensure the `EMSDK` environment variable is set (this happens automatically when you run `source ./emsdk_env.sh`).

## Files

- `build.dart`: The build script that configures CMake with Emscripten
- `src/CMakeLists.txt`: CMake configuration for building the WebAssembly module
- `src/my_library.c`: Simple C library with functions to export to WebAssembly

## Usage

To build the WebAssembly module:

```bash
dart run build.dart
```

This will generate:
- `my_wasm_library.wasm`: The WebAssembly module
- `my_wasm_library.js`: JavaScript loading code (if `generateJs: true`)

## Integration

The generated WebAssembly files can be integrated into:
- Flutter web applications (place in `web/assets/`)
- Standard web applications
- Node.js applications

The exported functions (`my_function` and `calculate_area`) will be available for calling from JavaScript/Dart code.