# frozen_string_literal: true

require "spec_helper"
require "params_collector/parser"
require "params_collector/marshaler/bool_marshaler"

module ParamsCollector
  module Marshaler
    describe BoolMarshaler do
      Given!(:marshaler) { BoolMarshaler.new }

      describe "getting default value" do
        Then { marshaler.value == false }
      end

      describe "setting default value" do
        Given { marshaler.set true }
        When { marshaler.set nil }
        Then { marshaler.value == false }
      end

      describe "setting positive value" do
        context "when unkown string given" do
          When { marshaler.set "asdada" }
          Then { marshaler.value == true }
        end

        context "when positive number given" do
          When { marshaler.set 2 }
          Then { marshaler.value == true }
        end

        context "when true given" do
          When { marshaler.set true }
          Then { marshaler.value == true }
        end
      end

      describe "setting negative value" do
        context "when no string given" do
          When { marshaler.set "no" }
          Then { marshaler.value == false }
        end

        context "when false string given" do
          When { marshaler.set "false" }
          Then { marshaler.value == false }
        end

        context "when off string given" do
          When { marshaler.set "off" }
          Then { marshaler.value == false }
        end

        context "when of string given" do
          When { marshaler.set "of" }
          Then { marshaler.value == false }
        end

        context "when 0 string given" do
          When { marshaler.set "0" }
          Then { marshaler.value == false }
        end

        context "when nil string given" do
          When { marshaler.set "nil" }
          Then { marshaler.value == false }
        end

        context "when empty string given" do
          When { marshaler.set "" }
          Then { marshaler.value == false }
        end

        context "when uppercase negative string given" do
          When { marshaler.set "FALsE" }
          Then { marshaler.value == false }
        end

        context "when nil given" do
          When { marshaler.set nil }
          Then { marshaler.value == false }
        end

        context "when false given" do
          When { marshaler.set false }
          Then { marshaler.value == false }
        end

        context "when 0 given" do
          When { marshaler.set 0 }
          Then { marshaler.value == false }
        end
      end
    end
  end
end
