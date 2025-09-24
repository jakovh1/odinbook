require 'rails_helper'

RSpec.describe "chats/index", type: :view do
  before(:each) do
    assign(:chats, [
      Chat.create!(),
      Chat.create!()
    ])
  end

  it "renders a list of chats" do
    render
    cell_selector = 'div>p'
  end
end
