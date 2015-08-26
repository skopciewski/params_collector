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
    end

    def parse(params)
      params.each do |key, val|
        prepare_param(key, val) if @params.key?(key.to_sym)
      end
    end

    def valid?
      ! @valid.any? { |_, value| value == false }
    end

    def [](name)
      @params[name].value
    end

    private

    def declare_params(key, default, marshaler)
      marshaler_instance = marshaler.new
      valid_state = false
      unless default.nil?
        marshaler_instance.set(default)
        valid_state = true
      end
      key = key.to_sym
      @params[key] = marshaler_instance
      @valid[key] = valid_state
    end

    def prepare_param(key, value)
      key = key.to_sym
      @params[key].set(value)
      @valid[key] = true
    end

    def self.register_marshaler(name, marshaler)
      method_text = "def #{name}(key, default = nil)
        declare_params(key, default, #{marshaler})
      end"
      Parser.module_eval(method_text)
    end
  end
end
