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

  describe "#equalize" do
    let(:controller) { ToolsController.new }
    uploaded_file = build_test_mpeg
    invalid_uploaded_file = build_test_mov

    let(:audio_input) { uploaded_file }
    let(:direction) { :radio }

    context "when the audio_input is invalid" do
      it "should raise an error" do
        audio_input = invalid_uploaded_file
        expect { Tool.equalize(audio_input, direction) }.to raise_error(ArgumentError)
      end
    end

    context "when the direction is invalid" do
      it "should raise an error" do
        direction = :invalid
        expect { Tool.equalize(audio_input, direction) }.to raise_error(ArgumentError)
      end
    end

    context "when the direction is radio" do
      it "should create a new audio file in public" do
        # Call the `equalize` method.
        output = Tool.equalize(audio_input, :radio)
        output_file_path = Rails.root.join('public', 'equalized_audio', output)

        # Assert that the output file was created.
        expect(File.exist?(output_file_path)).to be true

        # Delete the file
        Open3.popen3("rm #{output_file_path}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "# File deleted successfully"
          else
            puts "# Error deleting file: #{stderr.read}"
          end
        end
      end
    end

    context "when the direction is highpass" do
      it "should create a new audio file in public" do
        # Call the `equalize` method.
        output = Tool.equalize(audio_input, :highpass)
        output_file_path = Rails.root.join('public', 'equalized_audio', output)

        # Assert that the output file was created.
        expect(File.exist?(output_file_path)).to be true

        # Delete the file
        Open3.popen3("rm #{output_file_path}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "# File deleted successfully"
          else
            puts "# Error deleting file: #{stderr.read}"
          end
        end
      end
    end

    context "when the direction is lowpass" do
      it "should create a new audio file in public" do
        # Call the `equalize` method.
        output = Tool.equalize(audio_input, :lowpass)
        output_file_path = Rails.root.join('public', 'equalized_audio', output)

        # Assert that the output file was created.
        expect(File.exist?(output_file_path)).to be true

        # Delete the file
        Open3.popen3("rm #{output_file_path}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "# File deleted successfully"
          else
            puts "# Error deleting file: #{stderr.read}"
          end
        end
      end
    end

    context "when the direction is vocal" do
      it "should create a new audio file in public" do
        # Call the `equalize` method.
        output = Tool.equalize(audio_input, :vocal)
        output_file_path = Rails.root.join('public', 'equalized_audio', output)

        # Assert that the output file was created.
        expect(File.exist?(output_file_path)).to be true

        # Delete the file
        Open3.popen3("rm #{output_file_path}") do |stdin, stdout, stderr, wait_thr|
          # Check if the command was successful
          if wait_thr.value.success?
            puts "# File deleted successfully"
          else
            puts "# Error deleting file: #{stderr.read}"
          end
        end
      end
    end
  end
end
