module RSpec
  module Virtus
    class Matcher
      def initialize(attribute_name)
        @attribute_name = attribute_name
        @options = {}
      end

      def description
        msg = "have attribute #{@attribute_name}"
        msg << ", #{@options[:type]}" if @options[:type]
        msg << ", default: #{@options[:default_value]}" if @options[:default_value]
        msg
      end

      def of_type(type, options = {})
        @options[:type] = type
        @options[:member_type] = options.delete(:member_type)
        self
      end

      def with_default(default_value)
        @options[:default_value] = default_value
        self
      end

      def with_required(value)
        @options[:required] = value
        self
      end

      def matches?(instance)
        @instance = instance
        @subject = instance.class
        attribute_exists? && type_correct? && default_value_correct? && required?
      end

      def failure_message
        "should #{@attribute_name} to be defined"
      end

      def failure_message_when_negated
        "should #{@attribute_name} not to be defined"
      end

      private

      def attribute
        @subject.attribute_set[@attribute_name]
      end

      def member_type
        attribute.member_type.primitive
      end

      def attribute_type
        attribute.primitive
      end

      def attribute_exists?
        !attribute.nil?
      end

      def attribute_default_value
        value = attribute.default_value.value

        case value
        when ::Proc
          value.call(@instance, attribute)
        when ::Symbol
          @instance.__send__(value)
        else
          value
        end
      end

      def type_correct?
        if @options[:member_type]
          member_type == @options[:member_type] && attribute_type == @options[:type]
        elsif @options[:type]
          attribute_type == @options[:type]
        else
          true
        end
      end

      def default_value_correct?
        return true unless @options[:default_value]
        attribute_default_value == @options[:default_value]
      end

      def required?
        return true if @options[:required].nil?
        attribute.required? == @options[:required]
      end
    end
  end
end
