require "csv"

module ESpeak
  class Voice
    getter :language, :name, :gender, :file
    def initialize(language, name, gender, file)
      @language = language
      @name     = name
      @gender   = gender
      @file     = file
    end

    def self.all
      voices = [] of Voice
      CSV.parse(espeak_voices, headers: :first_row, col_sep: " ") do |row|
        voices << Voice.new(language: row[1], gender: row[2], name: row[3], file: row[4] )
      end
      voices
    end

    def self.find_by_language(lang)
      all.find { |v| v.language == lang.to_s }
    end

    def self.espeak_voices
      `espeak --voices`
    end
  end
end
