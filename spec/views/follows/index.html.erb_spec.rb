require 'rails_helper'

RSpec.describe "follows/index", type: :view do
  before(:each) do
    assign(:follows, [
      Follow.create!(
        follower: nil,
        followee: nil,
        status: "Status"
      ),
      Follow.create!(
        follower: nil,
        followee: nil,
        status: "Status"
      )
    ])
  end

  it "renders a list of follows" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
