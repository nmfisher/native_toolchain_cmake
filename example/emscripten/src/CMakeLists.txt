cmake_minimum_required(VERSION 3.10)
project(my_wasm_library C)

# Set C standard
set(CMAKE_C_STANDARD 99)

# Create the WebAssembly library
add_executable(my_wasm_library my_library.c)

# Only add Emscripten-specific settings after the project is configured
if(EMSCRIPTEN)
    # Use SHELL: prefix to pass flags correctly to emcc
    target_link_options(my_wasm_library PRIVATE
        "SHELL:-s WASM=1"
        "SHELL:-s EXPORTED_FUNCTIONS=[_my_function,_calculate_area]"
        "SHELL:-s EXPORTED_RUNTIME_METHODS=[ccall,cwrap]"
        "SHELL:-s ALLOW_MEMORY_GROWTH=1"
    )
endif()