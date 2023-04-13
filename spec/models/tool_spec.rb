require 'rails_helper'

RSpec.describe Tool, type: :model do
  let(:tool) {
    Tool.new(
      name: "ChatGPT Inspo Machine",
      note: "this is a machine that gives you AI generated promts for any art piece you want",
      links: ["https://openai.com/blog/chatgpt"],
      user: User.create(email: "grant@gmail.com", password: "123123"),
      internal_categories: "category_placeholder"
    )
  }

  it "is valid with all columns filled" do
    expect(tool.valid?).to eq(true)
  end

  context 'when missing name' do
    before do
      tool.name = ""
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
      tool.note = ""
    end

    it "is valid with no note" do
      expect(tool.valid?).to eq(true)
    end
  end
end
