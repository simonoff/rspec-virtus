# RSpec::Virtus [![Build Status](https://travis-ci.org/simonoff/rspec_virtus.png?branch=master)](https://travis-ci.org/simonoff/rspec_virtus) [![Code Climate](https://codeclimate.com/github/simonoff/rspec_virtus.png)](https://codeclimate.com/github/simonoff/rspec_virtus)

Simple RSpec matchers for your Virtus objects

## Installation

Add this line to your application's Gemfile:

    gem 'rspec_virtus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_virtus

Add to your `spec_helper` file next line:

    require 'rspec/virtus'

## Usage

Here is a sample Virtus object

    class Post
      include Virtus.model
      attribute :title, String
      attribute :body, String
      attribute :some_default, String, default: 'WOW!'
      attribute :comments, Array[String]
    end

And with `rspec_virtus` we can now make simple assertions about these models

    require 'spec_helper'

    describe Post
      describe 'attributes' do
        it { is_expected.to have_virtus_attribute(:title) }

        it { is_expected.to have_virtus_attribute(:body).of_type(String) }

        it { is_expected.to have_virtus_attribute(:some_default).with_default('WOW!') }

        it { is_expected.to have_virtus_attribute(:comments).of_type(String, member_type: String) }

      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
