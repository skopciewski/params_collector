# encoding: utf-8

# Copyright (C) 2015 Szymon Kopciewski
#
# This file is part of ParamsCollector.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module ParamsCollector
  def self.expect(&proc)
    parser = Parser.new
    parser.instance_eval(&proc)
    parser
  end

  class Parser
    def initialize
      @valid = {}
      @params = {}
      @defaults = {}
    end

    def parse(params)
      params.each do |key, value|
        key = key.to_sym
        prepare_param(key, value) if @params.key?(key.to_sym)
      end
    end

    def valid?
      ! @valid.any? { |_, value| value == false }
    end

    def [](name)
      @params[name].value
    end

    def to_hash
      @params.each_with_object({}) do |(key, marshaler), result|
        result[key] = marshaler.value if presentable?(key)
        result
      end
    end

    def merge(params)
      new_parser = dup
      new_parser.parse(params)
      new_parser.to_hash
    end

    private

    def declare_params(key, default, marshaler)
      marshaler_instance = marshaler.new
      marshaler_instance.set(default)
      @params[key] = marshaler_instance
      @defaults[key] = marshaler_instance.dup
      @valid[key] = !default.nil?
    end

    def prepare_param(key, value)
      @params[key].set(value)
      @valid[key] = true
    end

    def presentable?(key)
      @valid[key] && different_than_default?(key)
    end

    def different_than_default?(key)
      @params[key].value != @defaults[key].value
    end

    def self.register_marshaler(name, marshaler)
      method_text = "def #{name}(key, default = nil)
        key = key.to_sym
        declare_params(key, default, #{marshaler})
      end"
      Parser.module_eval(method_text)
    end
  end
end
