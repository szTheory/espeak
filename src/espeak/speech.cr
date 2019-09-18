module Espeak
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

    @text   : String
    @voice  : String
    @pitch  : Int32
    @speed  : Int32
    @capital: Int32
    @quiet  : Bool

    getter :text, :voice, :pitch, :speed, :capital, :quiet

    # filename - The file that will be generated
    #   :voice     - use voice file of this name from espeak-data/voices. ie "en", "de", ...
    #   :pitch     - pitch adjustment, 0 to 99
    #   :speed     - speed in words per minute, 80 to 370
    #   :capital   - increase emphasis of capitalized letters by raising pitch by this amount
    #                no range given in man but good range is 10-40 to start
    #   :quiet     - remove printing to stdout. Affects only lame (default false)
    #
    def initialize(text, *, voice=DEFAULT_VOICE, pitch=DEFAULT_PITCH, speed=DEFAULT_SPEED, capital=DEFAULT_CAPITAL, quiet=DEFAULT_QUIET)
      @text    = text
      @voice   = voice
      @pitch   = pitch
      @speed   = speed
      @capital = capital
      @quiet   = quiet
    end

    # Speaks text
    #
    def speak
      cmd = cmd_join(espeak_command, "r")
      Process.run(cmd) do |process|
        process.read
      end
    end

    # Generates mp3 file as a result of
    # Text-To-Speech conversion.
    #
    def save(filename)
      speech = bytes_wav
# debugger

      cmd = cmd_join(lame_command(filename), "r+")
      puts "---------"
      puts "cmd: #{cmd}"
      puts "---------"
      res = Process.run(cmd) do |process|
        puts "+++++"
        puts process.inspect
        # process.input.write(speech)
        # process.output.close
        # process.
        process.output.gets
        process.close
      end
      res.to_s
    end

    # Returns mp3 file bytes as a result of
    # Text-To-Speech conversion.
    #
    def bytes()
      speech = bytes_wav
      cmd = cmd_join(std_lame_command, "r+")
      res = Process.run(cmd) do |process|
        process.input.write(speech)
        process.output.gets
        process.close
      end
      res.to_s
    end

    # Returns wav file bytes as a result of
    # Text-To-Speech conversion.
    #
    def bytes_wav()
      cmd = cmd_join(espeak_command("--stdout"), "r")
      Process.run(cmd) do |process|
        process.output.gets
        process.close
      end
    end


    private def espeak_command(flags="")
      cmd_join do
        ["espeak", "#{text}", "#{flags}", "-v#{voice}", "-p#{pitch}", "-k#{capital}", "-s#{speed}"]
      end
    end

    private def std_lame_command
      lame_command("-")
    end

    private def lame_command(filename)
      cmd_join do
        ["lame", "-V2", "-", "#{filename}", "#{"--quiet" if quiet == true}"]
      end
    end

    # This pattern uses method overloading to do
    # the equivalent of Ruby's `block_given?`
    # ref: https://stackoverflow.com/questions/46860848/equivalent-of-ruby-block-given-in-crystal
    private def cmd_join(*command)
      cmd_join { command }
    end
    private def cmd_join(*command)
      (command || yield).join(' ')
    end
  end
end
