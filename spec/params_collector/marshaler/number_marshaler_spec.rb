# encoding: utf-8

require "spec_helper"
require "params_collector/parser"
require "params_collector/marshaler/number_marshaler"

module ParamsCollector
  module Marshaler
    describe NumberMarshaler do
      Given!(:marshaler) { NumberMarshaler.new }

      describe "getting default value" do
        Then { marshaler.value == 0 }
      end

      describe "setting default value" do
        Given { marshaler.set 123 }
        When { marshaler.set nil }
        Then { marshaler.value == 0 }
      end

      describe "setting integer value" do
        When { marshaler.set 1 }
        Then { marshaler.value == 1 }
      end

      describe "setting float value" do
        When { marshaler.set 2.2 }
        Then { marshaler.value == 2.2 }
      end

      describe "setting value from strin" do
        context "when valid integer string given" do
          When { marshaler.set "123" }
          Then { marshaler.value == 123 }
        end

        context "when valid float string given" do
          When { marshaler.set "22.1" }
          Then { marshaler.value == 22.1 }
        end

        context "when invalid string given" do
          When { marshaler.set "asd123" }
          Then { marshaler.value == 0 }
        end
      end
    end
  end
end
