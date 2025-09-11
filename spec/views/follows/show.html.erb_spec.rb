require 'rails_helper'

RSpec.describe "follows/show", type: :view do
  before(:each) do
    assign(:follow, Follow.create!(
      follower: nil,
      followee: nil,
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Status/)
  end
end
