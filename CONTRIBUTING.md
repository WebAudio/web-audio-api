# How to contribute

This repository containes the current Web Audio API _standard document_, developed by the Audio Working Group at the W3C. There are _multiple implementations_ of the Web Audio API standard.

If you're about to open an issue about a bug in a particular implementation, please file a ticket in the corresponding implementation bug tracker instead:

- WebKit (Safari): https://bugs.webkit.org/enter_bug.cgi?product=WebKit&component=Web%20Audio (WebKit bugzilla account needed).
- Blink (Chrome, Chromium, Electron apps, etc.): https://new.crbug.com/ (Google account needed).
- Gecko (Firefox): https://bugzilla.mozilla.org/enter_bug.cgi?product=Core&component=Web%20Audio (GitHub or Mozilla Bugzilla account needed).

Testing the same Web Audio API code in multiple implementations can be a quick way to check if an implementation has a bug. However, it has happened that different implementation have the same bug, so it's best to read the [standard document](https://webaudio.github.io/web-audio-api/), and to check what _should_ happen.

Feature requests are welcome, but a quick search in the [opened and closed issues](https://github.com/WebAudio/web-audio-api/issues) is welcome to avoid duplicates.

Pull requests are also welcome, but any change to the standard (barring things like typos and the like) will have to be discussed in an issue (and possibly during a call, accessible only to W3C Audio Working Group members).

[Bikeshed](https://github.com/tabatkins/bikeshed) is the tool used to write this
specification. It can either be used via an HTTP API, or by running it locally.

To use it via the HTTP API, run:

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 -F output=err -o err && cat err | sed -E 's/\\033\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | diff -u - expected-errs.txt
```

and preview your changes by doing: 
```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 > index.html
```

and opening `index.html` in your favorite browser.

To run it locally, follow the [installation
instructions](https://tabatkins.github.io/bikeshed/#installing).

Then, `bikeshed serve` will run a web server [locally on port
8000](http://localhost:8000).

