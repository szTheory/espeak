require "./spec_helper"
require "file_utils"

Spectator.describe Espeak::Speech do
  describe "#save" do
    before_each do
      FileUtils.rm_rf("spec/tmp")
      FileUtils.mkdir_p("spec/tmp")
    end

    let(path) { "spec/tmp/test.mp3" }

    it "saves" do
      # expect do
        Espeak::Speech.new("Hello!").save(path)
      # end.to change { File.exists?(path) }.from(false).to(true)
      #  eql("Mp3 file not generated")
    end

    after_each do
      FileUtils.rm_rf("spec/tmp")
    end
  end
end