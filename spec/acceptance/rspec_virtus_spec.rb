require 'spec_helper'
require 'virtus'

class DummyPost
  include Virtus.model

  attribute :title, String
  attribute :body, String
  attribute :comments, Array[String]
  attribute :greeting, String, default: 'Hello!'
  attribute :default_lambda, String, default: ->(_, _) { 'Wow!' }
  attribute :customs, String, default: :custom_default_via_method
  attribute :lazy_customs, String, default: :custom_default_via_method, lazy: true
  attribute :some_required, String, default: 'FooBar', required: true

  def custom_default_via_method
    'Foo!'
  end

end

describe ::DummyPost do
  it { is_expected.to have_virtus_attribute(:title) }
  it { is_expected.to have_virtus_attribute(:body).of_type(String) }
  it { is_expected.to have_virtus_attribute(:comments).of_type(Array[String]) }
  it { is_expected.to have_virtus_attribute(:greeting).of_type(String).with_default('Hello!') }
  it { is_expected.to have_virtus_attribute(:default_lambda).of_type(String).with_default('Wow!') }
  it { is_expected.to have_virtus_attribute(:customs).of_type(String).with_default('Foo!') }
  it { is_expected.to have_virtus_attribute(:lazy_customs).of_type(String).with_default('Foo!').with_lazy(true) }
  it { is_expected.to have_virtus_attribute(:some_required).of_type(String).with_default('FooBar').with_required(true) }
end
