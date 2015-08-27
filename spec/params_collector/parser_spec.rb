# encoding: utf-8

require "spec_helper"
require "params_collector"

module ParamsCollector
  describe Parser do
    describe "without any expected params" do
      Given!(:parser) { ParamsCollector.expect {} }
      When { parser.parse(params) }

      context "without params" do
        Given(:params) { {} }
        Then { expect(parser).to be_valid }
      end

      context "when given some params" do
        Given(:params) { { a: 1, b: 2 } }
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

    describe "when expected two params" do
      Given!(:parser) do
        ParamsCollector.expect do
          boolean :option
          number :num
        end
      end
      When { parser.parse(params) }

      context "with one matching param" do
        Given(:params) { { num: "2" } }
        Then { parser[:option] == false }
        And { parser[:num] == 2 }
        And { expect(parser).not_to be_valid }
      end

      context "with two matching params" do
        Given(:params) { { option: "true", num: "2" } }
        Then { parser[:option] == true }
        And { parser[:num] == 2 }
        And { expect(parser).to be_valid }
      end
    end

    describe "setting default value" do
      Given!(:parser) do
        ParamsCollector.expect do
          number :num, 2
          string :desc
        end
      end
      When { parser.parse(params) }

      context "without any params" do
        Given(:params) { {} }
        Then { expect(parser).not_to be_valid }
        And { parser[:num] == 2 }
        And { parser[:desc] == "" }
        And { parser.to_hash == {} }
      end

      context "with num given" do
        Given(:params) { { num: 3 } }
        Then { expect(parser).not_to be_valid }
        And { parser[:num] == 3 }
        And { parser[:desc] == "" }
        And { parser.to_hash == { num: 3 } }
      end

      context "with desc given" do
        Given(:params) { { desc: "foo" } }
        Then { expect(parser).to be_valid }
        And { parser[:num] == 2 }
        And { parser[:desc] == "foo" }
        And { parser.to_hash == { desc: "foo" } }
      end

      context "with all params" do
        Given(:params) { { num: 3, desc: "foo" } }
        Then { expect(parser).to be_valid }
        And { parser[:num] == 3 }
        And { parser[:desc] == "foo" }
        And { parser.to_hash == { num: 3, desc: "foo" } }
      end
    end
  end
end
