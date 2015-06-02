require 'spec_helper'
require 'virtus'

class DummyPost
  include Virtus.model

  attribute :title, String
  attribute :body, String
  attribute :comments, Array[String]
  attribute :greeting, String, default: 'Hello!'
end

describe ::DummyPost do
  it { is_expected.to have_attribute(:title) }
  it { is_expected.to have_attribute(:body).of_type(String) }
  it { is_expected.to have_attribute(:comments).of_type(Array, member_type: String) }
  it { is_expected.to have_attribute(:greeting).of_type(String).with_default('Hello!') }
end
