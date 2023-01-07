require 'rails_helper'

RSpec.describe Deal, type: :model do
  before(:example) do
    @bassi = User.create(name: 'Bassi', email: 'jane@doe.com', password: 'pw1234')
  end
  subject { Deal.new(name: 'MacDonald Nugget', amount: 100, author_id: @bassi.id) }

  before { subject.save }

  it 'Name is required' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'Name is Valid' do
    subject.name = 'MacDonald Nugget'
    expect(subject).to be_valid
  end

  it 'Amount is required' do
    subject.amount = nil
    expect(subject).to_not be_valid
  end

  it 'Amount should not be String' do
    subject.amount = 'aaa'
    expect(subject).to_not be_valid
  end

  it 'Amount should be Int' do
    subject.amount = 50
    expect(subject).to be_valid
  end

  it 'Author is required' do
    subject.author_id = nil
    expect(subject).to_not be_valid
  end

  it 'Author should exist' do
    subject.author_id = 10
    expect(subject).to_not be_valid
  end

  it 'Author value should be Int and Exist' do
    subject.author_id = @bassi.id
    expect(subject).to be_valid
  end

  it 'Author value should not be String' do
    subject.author_id = '1'
    expect(subject).to_not be_valid
  end
end
