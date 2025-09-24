require 'rails_helper'

RSpec.describe "messages/edit", type: :view do
  let(:message) {
    Message.create!(
      content: "MyString",
      author: nil,
      chat: nil
    )
  }

  before(:each) do
    assign(:message, message)
  end

  it "renders the edit message form" do
    render

    assert_select "form[action=?][method=?]", message_path(message), "post" do
      assert_select "input[name=?]", "message[content]"

      assert_select "input[name=?]", "message[author_id]"

      assert_select "input[name=?]", "message[chat_id]"
    end
  end
end
