require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is not valid without email.' do
    subject.email = nil
    subject.password = 'password123'
    subject.username = 'someusername'
    subject.save
    expect(subject.errors[:email]).to eq([ "can't be blank", "is too short (minimum is 6 characters)", "invalid email address format" ])
  end

  it 'is not valid without password.' do
    subject.email = 'someuser@gmail.com'
    subject.password = nil
    subject.username = 'someusername'
    subject.save
    expect(subject.errors[:password]).to eq([ "can't be blank", "is too short (minimum is 8 characters)" ])
  end

  it 'is valid with all required attributes.' do
    subject.email = 'someuser@gmail.com'
    subject.password = 'password123'
    subject.username = 'someusername'
    expect(subject).to be_valid
  end

  it 'is not valid user with existing email.' do
    first_user = User.create!(email: 'someuser@gmail.com',
                              password: 'password123',
                              username: 'someusername')
    second_user = User.new(email: 'someuser@gmail.com',
                           password: 'passWord1234',
                           username: 'secondUser')

    second_user.save

    expect(second_user.errors[:email]).to include("has already been taken")
  end

  it 'is not valid user with existing username.' do
    first_user = User.create!(email: 'someuser@gmail.com',
                              password: 'password123',
                              username: 'someusername')
    second_user = User.new(email: 'seconduser@gmail.com',
                           password: 'passWord1234',
                           username: 'someusername')

    second_user.save

    expect(second_user.errors[:username]).to include("has already been taken")
  end

  it 'is not valid with too short email.' do
    subject.email = 'a@g.c'
    subject.password = 'password123'
    subject.username = 'someusername'
    subject.save
    expect(subject.errors[:email]).to include("is too short (minimum is 6 characters)")
  end

  it 'is not valid with too short username.' do
    subject.email = 'someuser@gmail.com'
    subject.password = 'password123'
    subject.username = 'so'
    subject.save
    expect(subject.errors[:username]).to include("is too short (minimum is 3 characters)")
  end

  it 'is not valid with too short password.' do
    subject.email = 'someuser@gmail.com'
    subject.password = 'pass12'
    subject.username = 'someusername'
    subject.save
    expect(subject.errors[:password]).to include("is too short (minimum is 8 characters)")
  end

  it 'is not valid with invalid email format.' do
    subject.email = 'abcdeg.com'
    subject.password = 'password123'
    subject.username = 'someusername'
    subject.save
    expect(subject.errors[:email]).to include("invalid email address format")
  end

  it 'is not valid with email differing only by case' do
    User.create!(email: 'Test@Email.com', password: 'password123', username: 'user1')
    user = User.new(email: 'test@email.com', password: 'password123', username: 'user2')
    user.save
    expect(user.errors[:email]).to include("has already been taken")
  end

  it 'is not valid with invalid username format' do
    user = User.new(email: 'user@example.com', password: 'password123', username: 'invalid username!')
    user.save
    expect(user.errors[:username]).to include("only allows letters, numbers, and underscores")
  end
end
