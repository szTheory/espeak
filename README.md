# espeak

espeak is a small Crystal API for utilizing [espeak](http://espeak.sourceforge.net) and [lame](http://lame.sourceforge.net/) to create Text-To-Speech mp3 files. It can also just speak (without saving). Port of the [espeak-ruby gem](https://github.com/dejan/espeak-ruby).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     espeak:
       github: szTheory/espeak
   ```

2. Run `shards install`

## Usage

```crystal
require "espeak"
```

## Examples


```crystal
# Speaks "YO!"
speech = ESpeak::Speech.new("YO!")
speech.speak # invokes espeak

# Creates hello-de.mp3 file
speech = ESpeak::Speech.new("Hallo Welt", voice: "de")
speech.save("hello-de.mp3") # invokes espeak + lame

# Lists voices
ESpeak::Voice.all.map { |v| v.language } # ["af", "bs", "ca", "cs", "cy", "da", "de", "el", "en", "en-sc", "en-uk", "en-uk-north", "en-uk-rp", "en-uk-wmids", "en-us", "en-wi", "eo", "es", "es-la", "fi", "fr", "fr-be", "grc", "hi", "hr", "hu", "hy", "hy", "id", "is", "it", "jbo", "ka", "kn", "ku", "la", "lv", "mk", "ml", "nci", "nl", "no", "pap", "pl", "pt", "pt-pt", "ro", "ru", "sk", "sq", "sr", "sv", "sw", "ta", "tr", "vi", "zh", "zh-yue"]

# Find particular voice
ESpeak::Voice.find_by_language('en') #<ESpeak::Voice:0x007fe1d3806be8 @language="en", @name="default", @gender="M", @file="default">
```

## Features

Currently only subset of espeak features is supported.

```crystal
voice:   'en',    # use voice file of this name from espeak-data/voices
pitch:   50,      # pitch adjustment, 0 to 99
speed:   170,     # speed in words per minute, 80 to 370
capital: 170,     # increase emphasis (pitch) of capitalized words, 1 to 40 (for natural sound, can go higher)
```

These are default values, and they can be easily overridden:

```crystal
Speech.new("Zdravo svete", voice: "sr", pitch: 90, speed: 200).speak
```

## Installing dependencies

### OS X

    brew install espeak lame

### Ubuntu

    apt-get install espeak lame

## Related

* [espeak-ruby](http://github.com/dejan/espeak-ruby) - original Ruby gem that this Crystal version was ported from
* [espeak-http](http://github.com/dejan/espeak-http) - Micro web app for Text-To-Speech conversion via HTTP powered by Ruby, Sinatra, lame, espeak and espeak-ruby

## Licence

espeak-ruby is released under the [MIT License](/MIT-LICENSE).


## Contributing

1. Fork it (<https://github.com/szTheory/espeak/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [szTheory](https://github.com/szTheory) - creator and maintainer
- [dejan](https://github.com/dejan/) - creator of the original [espeak-ruby](https://github.com/dejan/espeak-ruby)