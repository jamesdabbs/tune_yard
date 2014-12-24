# TuneYard

_With immense respect to [tUnE-yArDs](http://tune-yards.com/)_

TuneYard is a gem to allow remote interaction with [SonicPi](http://sonic-pi.net/) (outside of the built-in SonicPi IDE).

**Big Disclaimer:** this is built on some undocumented SonicPi internals which could very well break. It is sufficient for my somewhat limited purposes (namely, a SonicPi + [Camping](http://camping.io/) class project at [The Iron Yard](http://theironyard.com/academy/)), but has only been tested in that context (namely, OSX 10.10, Ruby 2.1, and SonicPi 2.2). Please let me know if you are interested in using this elsewhere; I'd love some motivation to help properly [extract SonicPi to a gem](https://groups.google.com/forum/#!topic/sonic-pi/fI455WKYJDo).

## Installation

Be sure you have installed [SonicPi](http://sonic-pi.net/). If it is installed to a non-default location, you may need to specify where to look for the bundled Ruby files:

```
$LOAD_PATH.unshift '/path/to/sonic pi/app/server'
require 'tune_yard'
```

## Usage

Play some boops

```
TuneYard.play do
  with_fx :reverb, mix: 0.2 do
    loop do
      play scale(:Eb2, :major_pentatonic, num_octaves: 3).choose, release: 0.1, amp: rand
      sleep 0.1
    end
  end
end
```

With a little ~~violence~~metaprogramming, the `play` function _should_ close over properly. Warning: there be dragons here.

```
def rate
  rrand 0.125, 1.5
end
delay = 0.25

TuneYard.play for: 2 do
  loop do
    sample :perc_bell, rate: rate
    sleep delay
  end
end
```
