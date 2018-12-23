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


## Lint/Analyzer
```
dartanalyzer .
```
