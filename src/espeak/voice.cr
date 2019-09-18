require "csv"

module Espeak
  class Voice
    ESPEAK_VOICES_COL_INDEX_LANGUAGE = 2
    ESPEAK_VOICES_COL_INDEX_GENDER   = 3
    ESPEAK_VOICES_COL_INDEX_NAME     = 4
    ESPEAK_VOICES_COL_INDEX_FILE     = 5

    @language: String
    @name    : String
    @gender  : String
    @file    : String

    getter :language, :name, :gender, :file

    def initialize(language, name, gender, file)
      @language = language
      @name = name
      @gender = gender
      @file = file
    end

    def self.all
      voices = [] of Voice

      # break up the output of `espeak --voices`
      # command into an array of lines
      voice_rows = espeak_voices.split("\n")

      # skip the header
      voice_rows = voice_rows[1..-1]

      voice_rows.each do |row|
        vals = row.split(/\s+/)

        # ignore trailing rows
        next if vals.size < ESPEAK_VOICES_COL_INDEX_FILE+1

        # pull relevant vals from row
        language = vals[2]
        gender   = vals[3]
        name     = vals[4]
        file     = vals[5]

        # build the voice
        voice = begin
          Voice.new(language: language, gender: gender, name: name, file: file)
        end

        # add voice to list
        voices << voice
      end
      
      voices
    end

    def self.find_by_language(lang)
      puts "++++"
      puts "++++"
      puts all.inspect
      puts "++++"
      puts "++++"
      all.find { |v| v.language == lang.to_s }
    end

    # Output looks like this:
    # 
    # Pty Language Age/Gender VoiceName          File          Other Languages
    #  5  af             M  afrikaans            other/af      
    #  5  an             M  aragonese            europe/an     
    def self.espeak_voices
      `espeak --voices`
    end
  end
end
