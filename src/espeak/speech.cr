module ESpeak
  class Speech
    getter :text

    # Although espeak itself has default options
    # I'm defining them here for easier generating
    # command (with simple hash.merge)
    DEFAULT_VOICE   = "en"
    DEFAULT_PITCH   = 50
    DEFAULT_SPEED   = 170
    DEFAULT_CAPITAL = 1
    DEFAULT_QUIET   = true

    # filename - The file that will be generated
    #   :voice     - use voice file of this name from espeak-data/voices. ie "en", "de", ...
    #   :pitch     - pitch adjustment, 0 to 99
    #   :speed     - speed in words per minute, 80 to 370
    #   :capital   - increase emphasis of capitalized letters by raising pitch by this amount
    #                no range given in man but good range is 10-40 to start
    #   :quiet     - remove printing to stdout. Affects only lame (default false)
    #
    def initialize(text, *, voice=DEFAULT_VOICE, pitch=DEFAULT_PITCH, speed=DEFAULT_SPEED, capital=DEFAULT_CAPITAL, quiet=DEFAULT_QUIET)
      @text = text
    end

    # Speaks text
    #
    def speak
      IO.popen(espeak_command, "r") do |process|
        process.read
      end
    end

    # Generates mp3 file as a result of
    # Text-To-Speech conversion.
    #
    def save(filename)
      speech = bytes_wav
      res = IO.popen(lame_command(filename), "r+") do |process|
        process.write(speech)
        process.close_write
        process.read
      end
      res.to_s
    end

    # Returns mp3 file bytes as a result of
    # Text-To-Speech conversion.
    #
    def bytes()
      speech = bytes_wav
      res = IO.popen(std_lame_command, "r+") do |process|
        process.write(speech)
        process.close_write
        process.read
      end
      res.to_s
    end

    # Returns wav file bytes as a result of
    # Text-To-Speech conversion.
    #
    def bytes_wav()
      IO.popen(espeak_command("--stdout"), "r") do |process|
        process.read
      end
    end


    private def espeak_command(flags="")
      ["espeak", "#{text}", "#{flags}", "-v#{voice}", "-p#{pitch}", "-k#{capital}", "-s#{speed}"]
    end

    private def std_lame_command
      lame_command("-")
    end

    private def lame_command(filename)
      ["lame", "-V2", "-", "#{filename}", "#{"--quiet" if quiet == true}"]
    end
  end
end
