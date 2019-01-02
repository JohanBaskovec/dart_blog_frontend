# Dart Blog
## Setup
### Dart SDK
See [the official website](https://www.dartlang.org/tools/sdk#install).

### Install webdev globally
```
pub global activate webdev
```

### SASS
Install Dart Sass from [Github](https://github.com/sass/dart-sass/releases) and put the folder in your PATH.

## Running
* Run Sass:
```
sass sass/main.scss web/styles.css --watch
```
This will generate the CSS file and source maps, and watch for change.
* Run webdev serve:
```
webdev serve --live-reload
```
This will run the server and reload on change (it reloads on CSS change too!)
* Create a new Javascript debug configuration, set the URL to http://localhost:8080.
* Run the Javascript debug configuration in debug mode.

## Testing
Running the tests in a browser requires a .html for each test,
and including every generate .js test file. Hopefully, the 
build_runner does it for you! 

This command actually generates the .js and .html for the test directory:
```
webdev serve --live-reload
```

### On the command line
To run the tests on the command line:
```
pub run build_runner test -- -p chrome
```
This runs the tests in headless Chrome and reports errors.

To run a single test on the command line, append the file name to the end of the command:
```
pub run build_runner test -- -p chrome test/example.dart
```

See https://pub.dartlang.org/packages/build_test.

(do not use `pub run test -p chrome` alone, it recompiles all files on every run)

### In the browser
You can list the test files and run them at http://localhost:8081.

To debug the tests in IntelliJ:
* create Javascript configuration.
* set these paths:
    * lib: http://localhost:8081/packages/blog_frontend
    * test: http://localhost:8081
* run in debug.

(FYI, the generated HTML and JS files are in .dart_tools/build/generated/blog_frontend)

## Lint/Analyzer
```
dartanalyzer .
```
You shouldn't have to run it on the command line manually because IntelliJ already analyzes
your code.
