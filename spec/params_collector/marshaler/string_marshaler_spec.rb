# frozen_string_literal: true

require "spec_helper"
require "params_collector/parser"
require "params_collector/marshaler/string_marshaler"

module ParamsCollector
  module Marshaler
    describe StringMarshaler do
      Given!(:marshaler) { StringMarshaler.new }

      describe "getting default value" do
        Then { marshaler.value == "" }
      end

      describe "setting default value" do
        Given { marshaler.set "foo" }
        When { marshaler.set nil }
        Then { marshaler.value == "" }
      end

      describe "setting string value" do
        When { marshaler.set "ala ma kota" }
        Then { marshaler.value == "ala ma kota" }
      end

      describe "setting number value" do
        When { marshaler.set 123 }
        Then { marshaler.value == "123" }
      end
    end
  end
end
