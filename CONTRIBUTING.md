# How to contribute

This repository containes the current Web Audio API _standard document_, developed by the Audio Working Group at the W3C. There are _multiple implementations_ of the Web Audio API standard.

If you're about to open an issue about a bug in a particular implementation, please file a ticket in the corresponding implementation bug tracker instead:

- WebKit (Safari): https://bugs.webkit.org/enter_bug.cgi?product=WebKit&component=Web%20Audio (WebKit bugzilla account needed).
- Blink (Chrome, Chromium, Electron apps, etc.): https://new.crbug.com/ (Google account needed).
- Gecko (Firefox): https://bugzilla.mozilla.org/enter_bug.cgi?product=Core&component=Web%20Audio (GitHub or Mozilla Bugzilla account needed).

Testing the same Web Audio API code in multiple implementations can be a quick way to check if an implementation has a bug. However, it has happened that different implementation have the same bug, so it's best to read the [standard document](https://webaudio.github.io/web-audio-api/), and to check what _should_ happen.

Feature requests are welcome, but a quick search in the [opened and closed issues](https://github.com/WebAudio/web-audio-api/issues) is welcome to avoid duplicates.

Pull requests are also welcome, but any change to the standard (barring things like typos and the like) will have to be discussed in an issue (and possibly during a call, accessible only to W3C Audio Working Group members).

After modifying index.bs, check it is still valid by running `curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 -F output=err -o err && cat err | sed -E 's/\\033\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | diff -u - expected-errs.txt`

You can preview your changes by running `curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 > index.html` and opening index.html in your favorite browser.

After having made a change to your local copy of this repository, tidy the document up with `tidy-html5`. The process is automated. On UNIX machines, simply running `make tidy` will do everything automatically (including downloading and compiling the correct version of `tidy-html5`). Pull requests that aren't clean won't be merged.
