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

  describe "#new" do
    it "should exist" do
      expect(controller).to respond_to(:new)
    end

    it "should render app/views/tools/new.html.erb" do
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

  describe "#edit" do
    it "should exist" do
      expect(controller).to respond_to(:edit)
    end

    it "should render app/views/tools/edit.html.erb" do
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
    end

    context "invalid direction" do
      it "redirects - status code 422" do
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
      get :generate_prompt, params: { character: "potato" }
      expect(response).to have_http_status(422).to include(prompt: /./)
    end

    context "missing input" do
      it "redirects - status code 422" do
        get :generate_prompt, params: { character: 5 }
        expect(response).to have_http_status(422)
      end
    end
  end
end
