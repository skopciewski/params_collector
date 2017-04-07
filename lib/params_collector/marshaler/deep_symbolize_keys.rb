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
    module DeepSymbolizeKeys
      def symbolize(data)
        if data.is_a?(Hash)
          build_symbolized_hash(data)
        elsif data.is_a?(Array)
          build_symbolized_array(data)
        else
          data
        end
      end

      private

      def build_symbolized_hash(data)
        data.each_with_object({}) do |(k, v), memo|
          memo[k.to_sym] = symbolize(v)
          memo
        end
      end

      def build_symbolized_array(data)
        data.each_with_object([]) do |v, memo|
          memo << symbolize(v)
          memo
        end
      end
    end
  end
end
