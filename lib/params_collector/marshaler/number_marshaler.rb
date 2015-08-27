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
  module Marshaler
    class NumberMarshaler
      ParamsCollector::Parser.register_marshaler("number", name)
      attr_reader :value

      def initialize
        @default_value = 0
        @value = @default_value
      end

      def set(value)
        @value = @default_value if value.nil?
        @value = value if value.is_a?(Fixnum) || value.is_a?(Float)
        @value = parse_string(value) if value.is_a?(String)
      end

      private

      def parse_string(value)
        if value.match(/^\d+$/)
          return value.to_i
        elsif value.match(/^[0-9\.]+$/)
          return value.to_f
        end
        @default_value
      end
    end
  end
end
