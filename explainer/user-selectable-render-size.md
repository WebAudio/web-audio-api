# User-Selectable Render Size
Raymond Toy

## Background
Historically, WebAudio has always rendered the graph in chunks of 128 frames,
called a [render
quantum](https://webaudio.github.io/web-audio-api/#render-quantum) in the specification.
This was probably a trade-off between function-call overhead and latency.
A smaller number would reduce latency, but the function call overhead would
increase.  With a larger value, the overhead is reduced, but the latency
increases because any change takes 128 frames to before reaching the output.  In
addition, Mac OS probably processed 128 frames at a time anyway.

## Issues
This has worked well over time, especially on desktop, but is particularly bad
on Android where 128 may not fit in well with Android's audio processing.  The
main problem is illustrated very well from the example from Paul Adenot in a
[comment to issue #13](https://github.com/WebAudio/web-audio-api-v2/issues/13#issuecomment-572469654),
reproduced below.

The example is an Android phone that has a native processing buffer size
of 192.  Since WebAudio processes 128 frames we have the following behavior:

|iteration | #	number of frames to render |	number of buffers to render |	leftover frames|
|---|---|---|---|
|0|	192|	2|	64|
|1|	192|	1|	0|
|2|	192|	2|	64|
|3|	192|	1|	0|
|4|	192|	2|	64|
|5|	192|	1|	0|

At a sample rate of 48 kHz, 128 frames would require 2.666 ms.  The net result
is that the **peak** CPU usage is twice has high as might be expected since,
every other time, you need to render the graph twice in 2.666 ms instead of once.
Then the max complexity of the graph is unexpectedly limited because of this.

However, if the WebAudio rendered 192 frames at a time, the CPU usage would
remain constant, and more complex graphs could be rendered because the peak CPU
would be same as the average.  This does increase latency a bit, but since
Android is already using a size of 192, there is no actual additional latency.

Finally, some applications do not need these low latency requirements, and may
also want AudioWorklets to process larger blocks to reduce function call
overhead.  In this case allowing render sizes of 1024 or 2048 could be
appropriate.

## API
To allow user-selectable render size, we propose the following API:

```idl
// New enum
enum AudioContextRenderSizeCategory {
  "default",
  "hardware"
};

dictionary AudioContextOptions {
  (AudioContextLatencyCategory or double) latencyHint = "interactive";
  float sampleRate;

  // New addition
  (AudioContextRenderSizeCategory or unsigned long) renderSizeHint = "default";
};

dictionary OfflineAudioContextOptions {
  unsigned long numberOfChannels = 1;
  required unsigned long length;
  required float sampleRate;
  
  // New addition
  (AudioContextRenderSizeCategory or unsigned long) renderSizeHint = "default";
};

partial interface BaseAudioContext {
  unsigned long renderSize;
};
```

This API assumes that we'll update `AudioContextOptions` and
`OfflineAudioContextOptions` with a new member, `renderSizeHint`, instead of
defining a new dictionary.

The "default" category means WebAudio will use its default render size of 128
as it currently does.

When a value is given for `renderSizeHint`, the UA is allowed to modify the
requested size to any appropriate size in a UA-specific way.

In any case, the actual render size used by the UA is reported by the attribute
`renderSize` of the `BaseAudioContext`.


### "hardware" Category
#### AudioContext
For an `AudioContext`, the "hardware" category means WebAudio will ask the
system for the appropriate render size for the output device.  The UA is allowed
to choose the "hardware" value as appropriate; it does not necessary reflect
what the OS may say is the hardware size.

#### OfflineAudioContext
For an 'OfflineAudioContext', there's no concept of "hardware", so "hardware" is
equivalent to "default".  Allowing an `OfflineAudioContext` to have a selectable
size enables testing of the render size.

We explicitly do not support selecting a render size when using the 
[3-arg constructor](https://webaudio.github.io/web-audio-api/#dom-offlineaudiocontext-offlineaudiocontext-numberofchannels-length-samplerate) for the `OfflineAudioContext`.

## Requirements
### Supported Sizes
All UA's must support a `renderSize` that is a power of two between 32 and 2048,
inclusive.

It is highly recommended that other sizes that are not a power of two be
supported.  This is particularly important on Android where sizes of 96, 144,
192, and 240 are quite common.  The the problem isn't limited to Android.
Windows generally wants 10 ms buffers so we want sizes of 440 or 480 for 44.1
kHz and 48 kHz, respectively.

### ScriptProcessorNode
The [construction of a `ScriptProcessorNode`](https://webaudio.github.io/web-audio-api/#dom-baseaudiocontext-createscriptprocessor)
requires a
[`bufferSize`](https://webaudio.github.io/web-audio-api/#dom-baseaudiocontext-createscriptprocessor-buffersize-numberofinputchannels-numberofoutputchannels-buffersize)
argument that must be a power of two.  This is fine with appropriate buffering,
but perhaps it would be better if the buffer sizes are defined to be a power of
two times the render size.  So, while the current allowed sizes are 0, `128*2`,
`128*2^2`, `128*2^3`, `128*2^4`, `128*2^5`, `128*2^6`, and `128*2^7`, we may
want to specify the sizes as 0, `r*2`, `r*2^2`, `r*2^3`, `r*2^4`, `r*2^5`,
`r*2^6`, and `r*2^7`, where `r` is the `renderSize`.


# Implementation Issues
Conceptually this change is relatively simple, but some nodes may have
additional complexities.  It is up to the UA to handle these appropriately.

## AnalyserNode Implementation
The `AnalyserNode` currently specifies powers of two both for the size of the
returned time-domain data and for the size of the frequency domain data.  This
is probably ok.

## ConvolverNode Implementation
For efficiency, the `ConvolverNode` is often implemented using FFTs.  Typically,
only power-of-two FFTs have been used because the render size was 128.  To
support user-selectable sizes, either more complex algorithms are needed to
buffer the data appropriately, or more general FFTs are required to support
sizes that are not a power of two.  It is up to the discretion of the UA to
implement this appropriately.

## ScriptProcessorNode Implementation
We've already proposed a change for the `ScriptProcessorNode`.
