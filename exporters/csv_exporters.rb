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

require 'csv'
require_relative '../models'

# Exporters module
module Exporters
  # CSV Exporter module
  module CSVExporters
    include Models

    # Export the sells
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

    # Export the sells
    class SellsExporter
      def initialize(from_date, to_date)
        @date_range = { from: from_date,
                        to: to_date }
      end

      # Is the date range too much?
      # @return [Boolean] true if it is too much, false if it is alright.
      def too_much_time?
        # 5184000 is 60 months in seconds.
        @date_range[:to] - @date_range[:from] > 5_184_000
      end

      def to_file(filepath)
        return false if too_much_time?

        lst = Sell.between_dates @date_range

        CSV.open filepath, 'w' do |csv|
          csv << Sell.get_csv_header
          lst.each do |product|
            csv << product.to_csv_array
          end
        end
      end
    end
  end
end
