# frozen_string_literal: true

# Copyright (C) 2015, 2016, 2017 Szymon Kopciewski
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

require "params_collector/marshaler/deep_symbolize_keys"

module ParamsCollector
  module Marshaler
    class ArrayMarshaler
      ParamsCollector::Parser.register_marshaler("array", name)

      include DeepSymbolizeKeys
      attr_reader :value

      def initialize
        @default_value = []
        @value = @default_value
      end

      def set(value)
        @value = @default_value if value.nil?
        @value = symbolize(value) if value.is_a?(Array)
      end
    end
  end
end
