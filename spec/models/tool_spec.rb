require 'rails_helper'
require 'streamio-ffmpeg'
require 'open3'
require_relative '../spec_methods'

RSpec.describe Tool, type: :model do
  let(:tool) {
    Tool.new(
      name: "ChatGPT Inspo Machine",
      note: "this is a machine that gives you AI generated promts for any art piece you want",
      links: ["https://openai.com/blog/chatgpt"],
      user: User.create(email: "grant@gmail.com", password: "123123"),
      internals: ['custom']
    )
  }

  it "saves the link to 'openai.com'" do
    expect(tool.links == ["https://openai.com/blog/chatgpt"]).to eq(true)
  end

  it "doesn't save the link to 0" do
    expect(tool.links == [0]).to eq(false)
  end

  it "saves the internals to 'openai.com'" do
    expect(tool.internals == ["custom"]).to eq(true)
  end

  it "doesn't save the internals to 0" do
    expect(tool.internals == [0]).to eq(false)
  end

  it "is valid with all columns filled (category: custom)" do
    expect(tool.valid?).to eq(true)
  end

  context 'when missing name' do
    before do
      tool.name = nil
    end

    it "is not valid with a missing name" do
      expect(tool.valid?).to eq(false)
    end
  end

  context 'when missing user' do
    before do
      tool.user = nil
    end

    it "is not valid with no user" do
      expect(tool.valid?).to eq(false)
    end
  end

  context "when missing note" do
    before do
      tool.note = nil
    end

    it "is valid with no note" do
      expect(tool.valid?).to eq(true)
    end
  end

  context "when missing internals" do
    before do
      tool.internals = nil
    end

    it "it is not valid when internals are not equal to an array" do
      expect(tool.valid?).to eq(false)
    end
  end

  context "with multiple internals" do
    before do
      tool.internals << "color_picker"
    end

    it "is valid with color picker and custom" do
      expect(tool.valid?).to eq(true)
    end
  end

  context "with invalid internals" do
    before do
      tool.internals << "!@#$%"
    end

    it "is not valid with an invalid internal category" do
      expect(tool.valid?).to eq(false)
    end
  end

  describe "#internal_array?" do
    context "with internals set to array" do
      let(:internals) { ["#$%^"] }

      it "returns true" do
        expect(tool.internal_array?).to eq(true)
      end
    end
  end

  describe "#equalize_audio" do
    let(:controller) { ToolsController.new }
    let(:audio_input) { FFMPEG::Movie.new("/Users/granthall/code/grantcko/rails-digatools/spec/audio_input.mp3") }
    let(:direction) { :radio }

    context "when the audio_input is invalid" do
      it "should raise an error" do
        audio_input = FFMPEG::Movie.new("/Users/granthall/code/grantcko/rails-digatools/spec/invalid_input.mov")
        expect { controller.equalize_audio(audio_input, direction) }.to raise_error(ArgumentError)
      end
    end

    context "when the direction is invalid" do
      it "should raise an error" do
        direction = :invalid
        expect { controller.equalize_audio(audio_input, direction) }.to raise_error(ArgumentError)
      end
    end

    context "when the direction is radio" do
      it "should create a new audio file in storage" do
        # Call the `equalize_audio` method.
        controller.equalize_audio(audio_input, :radio)
        output_file_path = "/Users/granthall/code/grantcko/rails-digatools/storage/equalized_audio/audio_input.mp3_output.mp3"

        # Assert that the output file was created.
        expect(File.exist?(output_file_path)).to be true

        # Delete the file
        Open3.popen3("rm #{output_file_path}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "File deleted successfully"
          else
            puts "Error deleting file: #{stderr.read}"
          end
        end
      end
    end

    context "when the direction is highpass" do
      it "should create a new audio file in storage" do
        # Call the `equalize_audio` method.
        controller.equalize_audio(audio_input, :highpass)
        file = "/Users/granthall/code/grantcko/rails-digatools/spec/audio_input_output.mp3"

        # Assert that the output file was created.
        expect(File.exist?(file)).to be true
        Open3.popen3("rm #{file}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "File deleted successfully"
          else
            puts "Error deleting file: #{stderr.read}"
          end
        end
      end
    end

    context "when the direction is lowpass" do
      it "should create a new audio file in storage" do
        # Call the `equalize_audio` method.
        controller.equalize_audio(audio_input, :lowpass)
        file = "/Users/granthall/code/grantcko/rails-digatools/spec/audio_input_output.mp3"

        # Assert that the output file was created.
        expect(File.exist?(file)).to be true
        Open3.popen3("rm #{file}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "File deleted successfully"
          else
            puts "Error deleting file: #{stderr.read}"
          end
        end
      end
    end

    context "when the direction is vocal" do
      it "should create a new audio file in storage" do
        # Call the `equalize_audio` method.
        controller.equalize_audio(audio_input, :vocal)
        file = "/Users/granthall/code/grantcko/rails-digatools/spec/audio_input_output.mp3"

        # Assert that the output file was created.
        expect(File.exist?(file)).to be true
        Open3.popen3("rm #{file}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "File deleted successfully"
          else
            puts "Error deleting file: #{stderr.read}"
          end
        end
      end
    end
  end
end
