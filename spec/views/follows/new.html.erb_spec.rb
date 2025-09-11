require 'rails_helper'

RSpec.describe "follows/new", type: :view do
  before(:each) do
    assign(:follow, Follow.new(
      follower: nil,
      followee: nil,
      status: "MyString"
    ))
  end

  it "renders new follow form" do
    render

    assert_select "form[action=?][method=?]", follows_path, "post" do
      assert_select "input[name=?]", "follow[follower_id]"

      assert_select "input[name=?]", "follow[followee_id]"

      assert_select "input[name=?]", "follow[status]"
    end
  end
end
