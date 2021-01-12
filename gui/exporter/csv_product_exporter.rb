# Copyright 2021 Christian Gimenez
#
# csv_product_exporter.rb
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

require 'fox16'
require_relative '../../exporters'
require_relative 'csv_exporter'

# User Interface module
module GUI
  # User Interface to export data
  module Exporters
    include Fox

    # Show options to export Products data to CSV.
    class CSVProductExporter < CSVExporter
      def initialize(...)
        super(...)

        @foptions.hide

        assign_handlers
      end

      protected

      def do_save
        puts "Writing #{@txtsave.text} CSV file."
        exporter = CSVExporters::ProductExporter.new
        exporter.to_file @txtsave.text
      end
    end
  end
end
