require 'rails_helper'
require_relative '../spec_methods'

RSpec.describe ToolsController, type: :controller do
  describe "GET #index" do
    it "should exist as a controller method" do
      expect(controller).to respond_to(:index)
    end

    it "should initalize the current user's tools as `@tools`" do
      fail # TODO
    end

    it "should render app/views/tools/index.html.erb" do
      fail # TODO
    end
  end

  describe "GET #show" do
    it "should exist as a controller method" do
      expect(controller).to respond_to(:show)
    end

    it "should initalize the current tool as `@tool`" do
      fail # TODO
    end

    it "should initialize the preset eq_directions as `@eq_directions`" do
      fail # TODO
    end

    it "should render app/views/tools/show.html.erb" do
      fail # TODO
    end
  end

  describe "POST #create" do
    it "should exist as a controller method" do
      expect(controller).to respond_to(:create)
    end

    it "should create a new instance of a tool" do
      fail # TODO
    end

    context "with invalid attributes" do
      it "redirects - status code 422" do
        fail # TODO
      end
    end
  end

  describe "PATCH #update" do
    it "should exist as a controller method" do
      expect(controller).to respond_to(:update)
    end

    it "should updates the instance of the tool" do
      fail # TODO
    end
  end

  describe "POST #destroy" do
    it "should exist as a controller method" do
      expect(controller).to respond_to(:destroy)
    end

    it "should destroy the instance of the tool" do
      fail # TODO
    end
  end

  describe "POST #equalize_audio" do
    let(:user) { User.create!(email: 'test@example.com', password: 'password') }
    let(:tool) { Tool.create!(name: 'test', note: 'test', internals: ['auto_equalizer'], user: user) }
    let(:file) { Rack::Test::UploadedFile.new(build_test_mpeg.path, 'audio/mpeg') }
    let(:invalid_file) { Rack::Test::UploadedFile.new(build_test_mov.path, 'audio/mpeg') }

    before do
      sign_in user
    end

    it "should exist as a controller method as a controller method" do
      expect(controller).to respond_to(:equalize_audio)
    end

    context "with params -> direction, file, user, and tool_id" do
      it "should return json" do
        post :equalize_audio, params: { direction: :radio, file: file, tool_id: tool.id }
        # expect response to include JSON
        fail # TODO
      end
    end

    context "invalid direction" do
      it "redirects to the show_path" do
        post :equalize_audio, params: { direction: :invalid_test, file: file, tool_id: tool.id }
        # expect response
        fail # TODO
      end
    end

    context "invalid or missing input" do
      it "redirects to the show_path" do
        post :equalize_audio, params: { direction: :radio, file: invalid_file, tool_id: tool.id }
        # expect response
        fail # TODO
      end
    end
  end

  describe "#random_photo_idea" do
    it "should return a non empty hash" do
      instance = ToolsController.new
      result = instance.send(:random_photo_idea)
      puts result
      expect(result).to be_a(Hash)
      expect(result).not_to be_empty
    end
  end
end
