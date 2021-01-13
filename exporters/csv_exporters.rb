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

    # Super class to export Sell and Purchase instances to CSV.
    class InventoryExporter
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
        InventoryExporter.too_much_time? @date_range[:from], @date_range[:to]
      end

      # Create the CSV file with the data
      #
      # If the date range is more than the allowed limit, this method returns
      # false and nothing would be saved.
      #
      # @param filepath [String] The file path. Warning: The file will be
      #   overwritten if it exists.
      # @return false if the date range is more than the allowed limit.
      def to_file(filepath)
        return false if too_much_time?

        lst = between_dates

        CSV.open filepath, 'w' do |csv|
          csv << csv_header
          lst.each do |object|
            csv << object.to_csv_array
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

      protected

      # Return instances that are between the @date_range Time range.
      #
      # @return [Array] The instances to save to the CSV.
      def between_dates
        raise 'Reimplement in subclass.'
      end

      # Return the CSV header to save to the file.
      #
      # @return [Array] An array of Strings.
      def csv_header
        raise 'Reimplement in subclass.'
      end
    end

    # Export the Sell instances to a CSV file.
    class SellExporter < InventoryExporter
      protected

      def between_dates
        Sell.between_dates @date_range
      end

      def csv_header
        Sell.csv_header
      end
    end

    # Export Purchase instances to a CSV file
    class PurchaseExporter < InventoryExporter
      protected

      def between_dates
        Purchase.between_dates @date_range
      end

      def csv_header
        Purchase.csv_header
      end
    end
  end
end
