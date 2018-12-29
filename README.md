## Setup
### Install webdev globally:
```
pub global activate webdev
```

##Debug in Intellij:
### Without live-reload
* Right click on web/index.html
* Click on "Debug index.html"
* Wait for the server to launch (in the Dart Dev Server tab)
* Reload the page

### With live-reload
* Run webdev serve:
```
webdev serve --live-reload
```
* Create a new Javascript debug configuration, set the URL 
to http://localhost:8080, and set the correct remote URL for source folders. 
(look in Chrome's network tab to see where it fetches the sources, 
and set the remote URL accordingly, for example lib/src is 
http://localhost:8080/packages/blog_frontend/src).
* Run the Javascript debug configuration in debug mode.

## Testing
Running the tests in a browser requires a .html for each test,
and including every generate .js test file. Hopefully, the 
build_runner does it for you! 

This command actually generates the .js and .html for the test directory:
```
webdev serve --live-reload
```
You can list the test files and run them at http://localhost:8081.

The HTML and JS files are in 
.dart_tools/build/generated/blog_frontend

To run the tests on the command line:
```
pub run build_runner test -- -p chrome
```
This runs the tests in headless Chrome and reports errors.

See https://pub.dartlang.org/packages/build_test.

(do not use `pub run test -p chrome` alone, it recompiles all files on every run)

## Lint/Analyzer
```
dartanalyzer .
```
