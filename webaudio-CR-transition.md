# Transition request, Web Audio API to Candidate Recommendation

## Document title, URLs, estimated publication date

Web Audio API

Latest published version:
   http://www.w3.org/TR/webaudio/
   
Latest editor's draft:
   https://webaudio.github.io/web-audio-api/
   
Date:
  first Tuesday or Thursday after a sucessful transition meeting

## Abstract

See https://webaudio.github.io/web-audio-api/#h-abstract

## Status

The Working Group expects to demonstrate 2 implementations of the
features listed in this specification by the end of the Candidate
Recommendation phase.

This document was published by the Web Audio Working Group as a
Candidate Recommendation. This document is intended to become a W3C
Recommendation. If you wish to make comments regarding this document,
please send them to the GitHub repository. You may also use the mailing
list public-audiof@w3.org (subscribe, archives) with [Performance
Timeline] at the start of your email's subject. W3C publishes a
Candidate Recommendation to indicate that the document is believed 
to be  stable and to encourage implementation by the developer community. 
This Candidate Recommendation is expected to advance to Proposed
Recommendation no earlier than 1 July 2017. All comments are welcome.

Please see the Working Group's draft implementation report.

Publication as a Candidate Recommendation does not imply endorsement by
the W3C Membership. This is a draft document and may be updated,
replaced or obsoleted by other documents at any time. It is
inappropriate to cite this document as other than work in progress.

This document was produced by a group operating under the 5 February
2004 W3C Patent Policy. W3C maintains a public list of any patent
disclosures made in connection with the deliverables of the group; that
page also includes instructions for disclosing a patent. An individual
who has actual knowledge of a patent which the individual believes
contains Essential Claim(s) must disclose the information in accordance
with section 6 of the W3C Patent Policy.

This document is governed by the 1 September 2015 W3C Process Document.

## Link to group's decision to request transition

@@ once decision taken @@

## Changes

https://github.com/WebAudio/web-audio-api/commits/gh-pages

The last Working Draft on 8 December 2015 introduced a substantive 
change: the deprecation of the old extensibility point, ScriptProcessorNode and its replacement 
with AudioWorker.

Since then, substantial effort has gone into fleshing out details of the AudioWorklet interface
https://webaudio.github.io/web-audio-api/#AudioWorklet

This was done in coordination with the Houdini taskforce, which specified Worklet and also PaintWorklet.

The remainder of Web Audio API is stable, has multiple implementations, and is widely used.

## Requirements satisfied
Thedre is a requirements document

https://www.w3.org/TR/webaudio-usecases/

all of the use cases listed there are met by Web Audio API.

## Dependencies met (or not)

This specification depends on on the Worklets Working Draft and WebRTC. 
Worklets is being implemented in Blink and in Firefox, and is believed stable. 
Web Audio tests for AudioWorklet will help test Worklet as well.

## Wide Review

The specification has received wide review, including presentation and active discussion 
at two sucessful Web Audio conferences and uptake by an entusiastic developer community. 

The specification was developed on GitHub, see the issues list

https://github.com/WebAudio/web-audio-api/issues


### Security and Privacy:

There is a security and privacy appendix
  https://webaudio.github.io/web-audio-api/#Security-Privacy-Considerations
  
### Accessibility:

This JavaScript API does not expose any user media controls, so although the constraints in Media Accessibility User Requirements
https://www.w3.org/WAI/PF/media-a11y-reqs/

were considered, they do not apply to this API.

### Internationalization:

Web Audio API was discussed at TPAC 2016 with the I18n Core chair, who confirmed that JavaScript APIs 
which do not expose human-readable text strings or take natural-language input do not constitute 
a problem for Internationalization.

### TAG

This specification has benefitted from extensive review by the TAG. Domenic Denicola was the lead 
reviewer. Changes were made in response to this review, and the TAG appears satisfied.

## Issues addressed

Thi issues list is on GitHub:

https://github.com/WebAudio/web-audio-api/issues

There are currently 65 open issues and 655 closed. 

Of those, 61 were feature requests that were deferred to the next version
https://github.com/WebAudio/web-audio-api/issues?utf8=%E2%9C%93&q=%20label%3A%22Feature%20Request%2FMissing%20Feature%22%20-label%3A%22V1%20(TPAC%202014)%22%20

## Formal Objections

None

## Implementation

There are implementations of Web Audio API in Safari, in Blink-based browsers such as Chrome, in 
Firefox, and in Microsoft Edge. This includes mobile implementations in Safari for iOS and 
Chrome for Android.

A draft implementation report is available:

https://webaudio.github.io/web-audio-api/implementation-report.html

The Working Group expects to demonstrate 2 implementations of the
features listed in this specification by the end of the Candidate
Recommendation phase.

There are no features at risk.

A test suite is in progress and available at
 https://github.com/w3c/web-platform-tests/tree/master/webaudio


## Patent disclosures

https://www.w3.org/2004/01/pp-impl/46884/status

