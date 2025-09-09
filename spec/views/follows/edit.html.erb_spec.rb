require 'rails_helper'

RSpec.describe "follows/edit", type: :view do
  let(:follow) {
    Follow.create!(
      follower: nil,
      followee: nil,
      status: "MyString"
    )
  }

  before(:each) do
    assign(:follow, follow)
  end

  it "renders the edit follow form" do
    render

    assert_select "form[action=?][method=?]", follow_path(follow), "post" do

      assert_select "input[name=?]", "follow[follower_id]"

      assert_select "input[name=?]", "follow[followee_id]"

      assert_select "input[name=?]", "follow[status]"
    end
  end
end
