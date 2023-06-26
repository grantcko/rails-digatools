require 'rails_helper'
require_relative '../spec_methods'

RSpec.describe ToolsController, type: :controller do
  describe "#index" do
    it "should exist" do
      expect(controller).to respond_to(:index)
    end

    it "should initalize the current user's tools as `@tools`" do
    end

    it "should render app/views/tools/index.html.erb" do
    end
  end

  describe "#show" do
    it "should exist" do
      expect(controller).to respond_to(:show)
    end

    it "should initalize the current tool as `@tool`" do
    end

    it "should initialize the preset eq_directions as `@eq_directions`" do
    end

    it "should render app/views/tools/show.html.erb" do
    end
  end

  describe "#create" do
    it "should exist" do
      expect(controller).to respond_to(:create)
    end

    it "should create a new instance of a tool" do
    end

    context "with invalid attributes" do
      it "redirects - status code 422" do
      end
    end
  end

  describe "#update" do
    it "should exist" do
      expect(controller).to respond_to(:update)
    end

    it "should updates the instance of the tool" do
    end
  end

  describe "#destroy" do
    it "should exist" do
      expect(controller).to respond_to(:destroy)
    end

    it "should destroy the instance of the tool" do
    end
  end

  describe "#equalize_audio" do
    it "should exist" do
      expect(controller).to respond_to(:equalize_audio)
    end

    it "should return a json with filepath" do
      post :equalize_audio, params: { direction: "lowpass", file: build_test_mpeg }
      puts "# #{response.body} #"
      expect(response.redirect?).to eq(false)
    end

    context "invalid direction" do
      it "redirects - status code 422" do
        post :equalize_audio, params: { direction: "potato", file: build_test_mpeg }
        expect(response.redirect?).to eq(true)
      end
    end

    context "invalid or missing input" do
      it "redirects - status code 422" do
      end
    end
  end

  describe "#generate_prompt" do
    it "should exist" do
      expect(controller).to respond_to(:generate_prompt)
    end

    it "returns a json with a `prompt`" do
      post :generate_prompt, params: { prompt: "potato" }
      puts response.body
      expect(response.body).to include(prompt: /.*/)
    end

    context "missing input" do
      it "redirects - status code 422" do
        post :generate_prompt, params: { character: 5 }
        expect(response).to have_http_status(422)
      end
    end
  end
end
