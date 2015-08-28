# encoding: utf-8

require "spec_helper"
require "params_collector/parser"
require "params_collector/marshaler/array_marshaler"

module ParamsCollector
  module Marshaler
    describe ArrayMarshaler do
      Given!(:marshaler) { ArrayMarshaler.new }

      describe "getting default value" do
        Then { marshaler.value == [] }
      end

      describe "setting default value" do
        Given { marshaler.set [1, 2] }
        When { marshaler.set nil }
        Then { marshaler.value == [] }
      end

      describe "setting value from array" do
        Given(:params) { [1, "foo", [1, 2], { x: 1, "y" => 2 }] }
        When { marshaler.set params }
        Then { marshaler.value == [1, "foo", [1, 2], { x: 1, y: 2 }] }
      end

      describe "setting value from other objects" do
        context "when string given" do
          When { marshaler.set "foo" }
          Then { marshaler.value == [] }
        end

        context "when number given" do
          When { marshaler.set 123 }
          Then { marshaler.value == [] }
        end

        context "when bool given" do
          When { marshaler.set true }
          Then { marshaler.value == [] }
        end
      end
    end
  end
end
