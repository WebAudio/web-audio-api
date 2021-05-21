# User-Selectable Render Size
Raymond Toy

## Background
Historically, WebAudio has always rendered the graph in chunks of 128 frames,
called a [render
quantum](https://webaudio.github.io/web-audio-api/#render-quantum) in the
specification.  This was probably a trade-off between function-call overhead and
latency.  A smaller number would reduce latency, but the function call overhead
would increase.  With a larger value, the overhead is reduced, but the latency
increases because any change takes more audio frames to reach the output.  In
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

However, if WebAudio rendered 192 frames at a time, the CPU usage would
remain constant, and more complex graphs could be rendered because the peak CPU
would be same as the average.  This does increase latency a bit, but since
Android is already using a size of 192, there is no actual additional latency.

Finally, some applications do not need these low latency requirements, and may
also want AudioWorklets to process larger blocks to reduce function call
overhead.  In this case allowing render sizes of 1024 or 2048 could be
appropriate.

## The API
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

### Enumeration Description
|Value|Description|
|--|--|
|"default"  | Default rendering size of 128 frames |
|"hardware" | Use an appropriate value for the hardware for an AudioContext or the default for an OfflineAudioContext|

#### AudioContext
For an AudioContext, the "hardware" category means a size is chosen that is
appropriate to the current output device.  For example, selecting "hardware" may
result in a size of 192 frames for the Android phone used in the example.

#### OfflineAudioContext
For an OfflineAudioContext, there's no concept of "hardware", so using
"hardware" is the same as "default".

### New Dictionary Members
#### AudioContextOptions
<dl>
  <dt> renderSizeHint, of type (AudioContextRenderSizeCategory or unsigned long), defaulting to "default"
  </dt>

  <dd>
  Identifies the render size for the context.  The preferred value of the
  <code>renderSizeHint</code> is one of the values from the
  <code>AudioContextRenderSizeCategory</code>.  However, an unsigned long value may be
  given to request an exact number of frames to use for rendering.  Powers of
  two between 64 and 2048, inclusive MUST be supported.  It is recommended that
  UA's support values that are not a power of two.

  If the requested value is not supported by the UA, the UA MUST round the value
  up to the next smallest value that is supported.  If this exceeds the maximum
  supported value, it is clamped to the max.
  </dd>
</dl>


#### OfflineAudioContextOptions
<dl>
  <dt> renderSizeHint, of type (AudioContextRenderSizeCategory or unsigned long), defaulting to "default"
  </dt>

  <dd>
  This has exactly the same meaning, behavior, and constraints as for an
  `AudioContext`.  However, for an OfflineContext, the value of "hardware" is
  the same as "default".
  </dd>
</dl>


### BaseAudioContext New Attributes

<dl>
  <dt> renderSize, of type <code>unsigned long</code>, readonly
  </dt>
  <dd>
    <p>
    This is the actual number of frames used to render the graph.  This may be
    different from the value requested by <code>renderSizeHint</code>.
    </p>
    <p>
    We explicitly do <bold>NOT</bold> support selecting a render size when using the
    <a href="https://webaudio.github.io/web-audio-api/#dom-offlineaudiocontext-offlineaudiocontext-numberofchannels-length-samplerate">3-arg constructor</a> for the <code>OfflineAudioContext</code>.
    </p>
  </dd>
</dl>

## Requirements
### Supported Sizes
All UA's must support a `renderSize` that is a power of two between 64 and 2048,
inclusive.

It is highly recommended that other sizes that are not a power of two be
supported.  This is particularly important on Android where sizes of 96, 144,
192, and 240 are quite common.  The the problem isn't limited to Android.
Windows generally wants 10 ms buffers so sizes of 440 or 480 for 44.1
kHz and 48 kHz, respectively, should be supported.

## Interaction with `latencyHint`
The
[`latencyHint`](https://www.w3.org/TR/webaudio/#dom-audiocontextoptions-latencyhint)
for an AudioContext can interact with the `renderSize`.  The
exact interaction between these is up to the UA to implement in a meaningful
way.  In particular, UAs that don't double buffer WebAudio's output, the
`latencyHint` value can be 0, independent of the `renderSize`.

However, for UAs that do double buffer, then, roughly, the `renderSize` chooses
the minimum possible latency, and the `latencyHint` can increase this
appropriately when possible.

* If `renderSize` is "default", then 128 frames is used to render the graph and
  `latencyHint` behaves as before.
* If 'renderSize` is "hardware", then the graph is rendered using the hardware
  size.  The latency value is chosen appropriately but the resulting latency
  value cannot be smaller than the hardware size.
* If `renderSize` is a number, the graph is rendered using the appropriate
  UA-supported value.  The `latencyHint` cannot produce latencies less than
  this.

#### Non-normative Note:
For example, suppose the "hardware" render size is 192 frames with a context
whose sample rate is 48 kHz.  Also assume that a "balanced" latency implies a
latency of 20 ms, and "playback" implies a latency of 200 ms.

Then, for

* "interactive", the latency will be `192*n` where `n` is 1, 2, 3,..., and is
  chosen by the UA
* "playback", the latency will be 20 ms.  This means the graph is rendered 5
  times (`5*192` = `20 ms * 48 kHz`) per callback.
* "playback", the latency will be 200 ms.  The graph is rendered 50 times per
  callback.
  
If, however, a render size of 1024 is selected, we have:

* "interactive", the latency will be `1024*n` where `n` is 1, 2, 3,..., and is
  chosen by the UA
* "playback", a latency of 20 ms is 960 frames, which is smaller than 1024.  The
  resulting latency will be 1024 frames (21.33 sec).
* "playback", the latency will be 200 ms since 200 ms is 9600 frames which is
  larger than 1024.


# Security and Privacy Issues
When the user requests "hardware" for the render size, the user's hardware
capability can be exposed and can be used to finger print the user.  While no UA
is required to return exactly the hardware value, it is most beneficial if it
actually did, as explained #issues.  But for privacy reasons, a UA can return a
different value.

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
implement this appropriately for all the supported render sizes.

### ScriptProcessorNode
The [construction of a
`ScriptProcessorNode`](https://webaudio.github.io/web-audio-api/#dom-baseaudiocontext-createscriptprocessor)
requires a
[`bufferSize`](https://webaudio.github.io/web-audio-api/#dom-baseaudiocontext-createscriptprocessor-buffersize-numberofinputchannels-numberofoutputchannels-buffersize)
argument that must be a power of two.  This is fine with appropriate buffering,
but perhaps it would be better if the buffer sizes are defined to be a power of
two times the render size.  So, while the current allowed sizes are 0, and
`128*2^n`, for `n` = 1, 2, ..., 7., we may want to specify the sizes as 0,
`r*2^n`, where `r` is the `renderSize`.

