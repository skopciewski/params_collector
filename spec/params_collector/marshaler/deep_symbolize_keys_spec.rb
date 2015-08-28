# encoding: utf-8

require "spec_helper"
require "params_collector/parser"
require "params_collector/marshaler/deep_symbolize_keys"

module ParamsCollector
  module Marshaler
    class TestSymbolizer
      extend DeepSymbolizeKeys

      def self.convert(data)
        symbolize(data)
      end
    end

    describe "converting keys to symbols" do
      When(:result) { TestSymbolizer.convert(data) }

      context "with hash" do
        Given(:data) { { a: 1, "b" => "2" } }
        Then { result == { a: 1, b: "2" } }
      end

      context "with nested hash" do
        Given(:data) { { a: { x: 1, "y" => 2 } } }
        Then { result == { a: { x: 1, y: 2 } } }
      end

      context "with array of hashes" do
        Given(:data) { [{ x: 1 }, { "y" => 2 }] }
        Then { result == [{ x: 1 }, { y: 2 }] }
      end
    end
  end
end
