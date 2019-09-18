require "./spec_helper"

Spectator.describe Espeak::Voice do
  let(voices_file) { File.read("spec/fixtures/voices.txt") }


  Mocks.create_mock Espeak::Voice do
    mock espeak_voices
  end

  before_each do
    allow(Espeak::Voice).to receive(espeak_voices).and_return(voices_file)
  end

  describe ".all" do
    subject(voices) { Espeak::Voice.all }

    it { expect(voices.size).to be > 0 }
    it { expect(["M", "F"]).to be_includes(voices.first.gender) }
  end

  describe ".find_by_language" do
    subject(voice) { Espeak::Voice.find_by_language(language) }
    let(language) { "en" }

    it do
      
    end
    # it { expect(voice.language).to eq(language) }
  end
end
