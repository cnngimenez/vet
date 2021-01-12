# Copyright 2021 Christian Gimenez
#
# csv_exporter.rb
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

# frozen_string_literal: true

require 'csv'
require_relative '../models'

# Exporters module
module Exporters
  # CSV Exporter module
  module CSVExporters
    include Models

    # Export Product instances to a CSV file.
    class ProductExporter
      def initialize; end

      def to_file(filepath)
        lst = Product.all
        CSV.open filepath, 'w' do |csv|
          csv << Product.csv_header
          lst.each do |product|
            csv << product.to_csv_array
          end
        end
      end
    end

    # Export the Sell instances to a CSV file.
    class SellExporter
      # Initialize the new instance.
      #
      # @param from_date [Time]
      # @param to_date [Time]
      def initialize(from_date, to_date)
        @date_range = { from: from_date, to: to_date }
      end

      # Is the date range too much?
      #
      # @return [Boolean] true if it is too much, false if it is alright.
      def too_much_time?
        SellExporter.too_much_time? @data_range[:from], @data_range[:to]
      end

      def to_file(filepath)
        return false if too_much_time?

        lst = Sell.between_dates @date_range

        CSV.open filepath, 'w' do |csv|
          csv << Sell.get_csv_header
          lst.each do |sell|
            csv << sell.to_csv_array
          end
        end
      end

      class << self
        # Is the date range too much?
        #
        # @return [Boolean] true if it is too much, false if it is alright.
        def too_much_time?(from, to)
          # 5184000 is 60 months in seconds.
          to - from > 5_184_000
        end
      end
    end
  end
end
