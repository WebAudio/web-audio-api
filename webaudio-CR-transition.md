# Transition request, Web Audio API to Candidate Recommendation

see https://github.com/w3c/transitions/issues/89

## Document title, URLs, estimated publication date

Web Audio API

Latest published version:
   http://www.w3.org/TR/webaudio/
   
Latest editor's draft:
   https://webaudio.github.io/web-audio-api/
   
Date:
  first Tuesday or Thursday after a sucessful transition meeting

## Abstract

See https://www.w3.org/TR/webaudio/#abstract

## Status

See https://www.w3.org/TR/webaudio/#sotd (as WD)

## Link to group's decision to request transition

[12:12] <mdjp> Agreement on transition request https://github.com/WebAudio/web-audio-api/blob/master/webaudio-CR-transition.md

[12:13] <mdjp> All in favour
   
[6 Sept 2018 telcon](https://www.w3.org/2018/09/06-audio-irc#T16-13-12-53).


## Changes

The Working Draft of 8 December 2015 introduced a substantive 
change: the deprecation of the old extensibility point, ScriptProcessorNode and its replacement 
with AudioWorker.

Since then, substantial effort has gone into fleshing out details of the AudioWorklet interface
https://webaudio.github.io/web-audio-api/#AudioWorklet

This was done in coordination with the Houdini taskforce, which specified Worklet and also PaintWorklet.

An updated draft was published on 19 June 2018 for wide review.

Changes between the 8 December 2015 Working Draft and the 19 June 2018 draft are listed in the changes section
https://webaudio.github.io/web-audio-api/#changestart

More recent changes are listed here
https://github.com/WebAudio/web-audio-api/commits/main/
and will be added to a separate changes subsection

The remainder of Web Audio API is stable, has multiple implementations, and is widely used.

## Requirements satisfied
There is a requirements document

https://www.w3.org/TR/webaudio-usecases/

the majority of the use cases listed there are met by Web Audio API. Speed change algorithms are complex and were not added in v.1 but could be implemented via AudioWorklet. We eliminated built-in Doppler shifting from the API because of complexity and CPU-consumption concerns. However, the effect would still be achievable within a game using continuous playbackRate control of an AudioBufferSourceNode generating the sound to be shifted. Some use cases would require substantial CPU power for professional results, but this is not an inherent limitation of the specification just of physics.

## Dependencies met (or not)

This specification depends on on the [Worklets Working Draft](https://www.w3.org/TR/worklets-1/) and [WebRTC](https://www.w3.org/TR/webrtc/). 
Worklets is being implemented in Blink and in Firefox, and is believed stable. 
Web Audio tests for AudioWorklet will help test Worklet as well.

## Wide Review

The most recent Working Draft was published on 19 June 2018
https://www.w3.org/TR/2018/WD-webaudio-20180619/

The specification has received wide review, including presentation and active discussion 
at three sucessful Web Audio conferences (fourth conference to take place September 2018)
and uptake by an enthusiastic developer community. 
These conferences have included public plenary sessions with the working group. 

[WAC 2015 http://wac.ircam.fr/](http://wac.ircam.fr/)

[WAC 2016 http://webaudio.gatech.edu/](http://webaudio.gatech.edu/)

[WAC 2017 http://wac.eecs.qmul.ac.uk/](http://wac.eecs.qmul.ac.uk/)

[WAC 2018 https://webaudioconf.com/](https://webaudioconf.com/)



The specification was developed on GitHub, see the issues list

https://github.com/WebAudio/web-audio-api/issues


### Security and Privacy:

There is a security and privacy appendix
  https://webaudio.github.io/web-audio-api/#Security-Privacy-Considerations
This benefitted from review and contributions of the Privacy Interest Group.
  
### Accessibility:

This JavaScript API does not expose any user media controls, so although the constraints in Media Accessibility User Requirements
https://www.w3.org/WAI/PF/media-a11y-reqs/

were considered, they do not apply to this API.

### Internationalization:

Web Audio API was discussed at TPAC 2016 with the I18n Core chair, who confirmed that JavaScript APIs 
which do not expose human-readable text strings or take natural-language input do not constitute 
a problem for Internationalization.

### TAG:

This specification benefitted from extensive review by the TAG. Domenic Denicola was the lead 
reviewer. Changes were made in response to this review, and the TAG appeared satisfied.

To verify this, a [second round of TAG review](https://github.com/w3ctag/design-reviews/issues/212)  
was initiated in Nov 2017. The spec was discussed with the TAG at their London f2f, and TAG confirmed they were satisfied.

## Issues addressed

The issues list is on GitHub:

https://github.com/WebAudio/web-audio-api/issues

There are currently 80 open issues and 978 closed. 

Of those, 95 were feature requests that were [deferred to the next version](https://github.com/WebAudio/web-audio-api/milestone/2)

WebAudio v.1 has [13 open issues and 433 closed](https://github.com/WebAudio/web-audio-api/milestone/1); these are primarily editorial clarifications.

## Formal Objections

None

## Implementation

There are implementations of Web Audio API in Safari, in Blink-based browsers such as Chrome, in 
Firefox, and in Microsoft Edge. This includes mobile implementations in Safari for iOS and 
Chrome and Firefox for Android.

A draft implementation report is available:

https://webaudio.github.io/web-audio-api/implementation-report.html

There are no features at risk.

A test suite is in progress and available at
 https://github.com/web-platform-tests/wpt/tree/master/webaudio
 
WPT.fy results are available (with the usual caveats regarding browser versions, etc)
  https://wpt.fyi/results/webaudio/the-audio-api

Mojitests from Mozilla are being converted to WPT format and will be pushed upstream to the WPR repo. These are all upstream reviewed.
Google also has extensive tests; these have now all been converted to WPT format, and have been pushed to WPT. These are all upstream reviewed. The tracking issue for test migration is 
https://github.com/WebAudio/web-audio-api/issues/1388

During the CR period, the WG expects to remove any test duplication and look for any untested areas.

The Working Group expects to demonstrate 2 implementations of the
features listed in this specification by the end of the Candidate
Recommendation phase.

## Patent disclosures

https://www.w3.org/2004/01/pp-impl/46884/status

