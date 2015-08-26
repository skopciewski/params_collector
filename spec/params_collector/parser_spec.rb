# encoding: utf-8

require "spec_helper"
require "params_collector"

module ParamsCollector
  describe Parser do
    describe "without any expected params" do
      Given!(:parser) { ParamsCollector.expect {} }
      Then { expect(parser).to be_valid }

      context "when given some params" do
        Given(:params) { { a: 1, b: 2 } }
        When { parser.parse(params) }
        Then { expect(parser).to be_valid }
      end
    end

    describe "with expected boolean param" do
      Given!(:parser) { ParamsCollector.expect { boolean :option } }
      When { parser.parse(params) }

      context "when no params parsed" do
        Given(:params) { {} }
        Then { parser[:option] == false }
        And { expect(parser).not_to be_valid }
      end

      context "when expected params parsed" do
        Given(:params) { { option: 1, foo: 2 } }
        Then { parser[:option] == true }
        And { expect(parser).to be_valid }
      end
    end

    describe "all keys to symbols" do
      Given!(:parser) { ParamsCollector.expect { boolean "option" } }
      Given(:params) { { "option" => 1 } }
      When { parser.parse(params) }
      Then { parser[:option] == true }
    end
  end
end
