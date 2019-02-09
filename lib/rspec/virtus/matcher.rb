module RSpec
  module Virtus
    class Matcher
      def initialize(attribute_name)
        @attribute_name = attribute_name
        @options = {}
      end

      def description
        msg = "have attribute #{@attribute_name}"
        msg << ", #{normalize_type}" if @options[:type]
        msg << ", default: #{@options[:default_value]}" if @options[:default_value]
        msg << ", required: #{@options[:required]}" unless @options[:required].nil?
        msg << ", lazy: #{@options[:lazy]}" unless @options[:lazy].nil?
        msg << ", writer: #{@options[:writer]}" unless @options[:writer].nil?
        msg
      end

      def of_type(type)
        @options[:type] = type
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

      def with_lazy(value)
        @options[:lazy] = value
        self
      end

      def with_writer(value)
        @options[:writer] = value
        self
      end

      def matches?(instance)
        @instance = instance
        @subject = instance.class
        @match_attribute_exists = attribute_exists?
        return false unless @match_attribute_exists
        @match_type_correct = type_correct?
        @match_default_value_correct = default_value_correct?
        @match_required_correct = required?
        @match_lazy_correct = lazy?
        @match_writer = writer?
        @match_attribute_exists && @match_type_correct && @match_default_value_correct && @match_required_correct && @match_lazy_correct && @match_writer
      end

      def failure_message
        msg = ["expected #{@attribute_name} to be defined"]
        msg << "have type #{normalize_type}" if @options.key?(:type) && !@match_type_correct
        msg << 'have correct default value'  if @options.key?(:default_value) && !@match_default_value_correct
        msg << 'have correct required flag'  if @options.key?(:required) && !@match_required_correct
        msg << 'have correct lazy flag'  if @options.key?(:lazy) && !@match_lazy_correct
        msg << "have #{@options[:writer]} writer" if @options.key?(:writer) && !@match_writer
        msg.join(' and ')
      end

      def failure_message_when_negated
        msg = ["expect #{@attribute_name} not to be defined"]
        msg << "not have type #{normalize_type}" if @options.key?(:type)
        msg << 'not have correct default value'  if @options.key?(:default_value)
        msg << 'not have correct required flag'  if @options.key?(:required)
        msg << 'not have correct lazy flag'  if @options.key?(:lazy)
        msg << "not have #{@options[:writer]} writer" if @options.key?(:writer)
        msg.join(' and ')
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
          @instance.respond_to?(value, true) ? @instance.__send__(value) : value
        else
          value
        end
      end

      def attribute_writer
        attribute.public_writer? ? :public : :private
      end

      def type_correct?
        if @options[:type].is_a?(::Array)
          attribute_type == @options[:type].class && member_type == @options[:type].first
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

      def lazy?
        return true if @options[:lazy].nil?
        attribute.lazy? == @options[:lazy]
      end

      def writer?
        return true if @options[:writer].nil?
        @options[:writer] == attribute_writer
      end

      def normalize_type
        if @options[:type].is_a?(::Array)
          "#{@options[:type].class}[#{@options[:type].first}]"
        else
          @options[:type]
        end
      end
    end
  end
end
