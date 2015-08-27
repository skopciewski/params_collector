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

    describe "all keys to symbols" do
      Given!(:parser) { ParamsCollector.expect { boolean "option" } }
      Given(:params) { { "option" => 1 } }
      When { parser.parse(params) }
      Then { parser[:option] == true }
    end

    describe "when expected many params" do
      Given!(:parser) do
        ParamsCollector.expect do
          boolean :option
          number :num
          boolean :option2
        end
      end
      When { parser.parse(params) }

      context "without params" do
        Given(:params) { {} }
        Then { parser[:option] == false }
        And { parser[:num] == 0 }
        And { expect(parser).not_to be_valid }
      end

      context "with one matching param" do
        Given(:params) { { num: "2" } }
        Then { parser[:option] == false }
        And { parser[:num] == 2 }
        And { expect(parser).not_to be_valid }
      end

      context "with two matching params" do
        Given(:params) { { option: "true", option2: "false", num: "2" } }
        Then { parser[:option] == true }
        And { parser[:option2] == false }
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

    describe ".merge" do
      Given!(:parser) do
        ParamsCollector.expect do
          boolean :option, false
          number :num, 2
          string :desc
        end
      end
      Given(:params) { { option: true, desc: "foo" } }
      Given(:new_params) { { desc: "bar", xxx: 0 } }
      Given { parser.parse(params) }
      When(:result) { parser.merge(new_params) }
      Then { result == { option: true, desc: "bar" } }
    end
  end
end
