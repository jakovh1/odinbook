require 'rails_helper'

RSpec.describe "chats/show", type: :view do
  before(:each) do
    assign(:chat, Chat.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
