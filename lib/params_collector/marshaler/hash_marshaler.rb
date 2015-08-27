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
    class HashMarshaler
      ParamsCollector::Parser.register_marshaler("hash", name)
      attr_reader :value

      def initialize
        @default_value = {}
        @value = @default_value
      end

      def set(value)
        @value = @default_value if value.nil?
        @value = normalize_hash(value) if value.is_a?(Hash)
      end

      private

      def normalize_hash(hash)
        hash.each_with_object({}) do |row, result|
          key = row[0].to_s
          value = row[1]
          result[key] = choose_normalizer(value)
          result
        end
      end

      def choose_normalizer(value)
        if value.is_a?(Array)
          normalize_array(value)
        elsif value.is_a?(Hash)
          normalize_hash(value)
        else
          value
        end
      end

      def normalize_array(array)
        array.map do |value|
          choose_normalizer(value)
        end
      end
    end
  end
end
