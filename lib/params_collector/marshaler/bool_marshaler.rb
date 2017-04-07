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

module ParamsCollector
  module Marshaler
    class BoolMarshaler
      ParamsCollector::Parser.register_marshaler("boolean", name)
      attr_reader :value

      def initialize
        @default_value = false
        @value = @default_value
      end

      def set(value)
        @value = @default_value if value.nil?
        @value = check_string(value) if value.is_a?(String)
        @value = true if value.is_a?(TrueClass)
        @value = value.positive? if value.is_a?(Integer) || value.is_a?(Float)
      end

      private

      def check_string(value)
        return false if value == ""
        negative_strings = %w(no false off of 0 nil)
        !negative_strings.include?(value.downcase)
      end
    end
  end
end
