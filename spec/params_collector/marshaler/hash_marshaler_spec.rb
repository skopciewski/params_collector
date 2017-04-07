# frozen_string_literal: true

require "spec_helper"
require "params_collector/parser"
require "params_collector/marshaler/hash_marshaler"

module ParamsCollector
  module Marshaler
    describe HashMarshaler do
      Given!(:marshaler) { HashMarshaler.new }

      describe "getting default value" do
        Then { marshaler.value == {} }
      end

      describe "setting default value" do
        Given { marshaler.set a: 1 }
        When { marshaler.set nil }
        Then { marshaler.value == {} }
      end

      describe "setting hash value" do
        Given(:params) { { a: 1, "b" => "foo", c: { x: 1, "y" => 2 } } }
        When { marshaler.set params }
        Then { marshaler.value == { a: 1, b: "foo", c: { x: 1, y: 2 } } }

        context "with nested array" do
          Given(:params) { { "a" => [123, { x: 1, "y" => 2 }] } }
          Then { marshaler.value == { a: [123, { x: 1, y: 2 }] } }
        end
      end

      describe "setting value from other objects" do
        context "when string given" do
          When { marshaler.set "foo" }
          Then { marshaler.value == {} }
        end

        context "when number given" do
          When { marshaler.set 123 }
          Then { marshaler.value == {} }
        end

        context "when bool given" do
          When { marshaler.set true }
          Then { marshaler.value == {} }
        end
      end
    end
  end
end
