#include <emscripten.h>

// Export function to be callable from JavaScript/Dart
EMSCRIPTEN_KEEPALIVE
int my_function(int a, int b) {
    return a + b;
}

// Another example function
EMSCRIPTEN_KEEPALIVE
double calculate_area(double width, double height) {
    return width * height;
}