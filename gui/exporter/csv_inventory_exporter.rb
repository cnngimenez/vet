# coding: utf-8
# Copyright 2021 Christian Gimenez
#
# csv_inventory_exporter.rb
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
require_relative 'csv_exporter'

module GUI
  # GUI to export the DB data to CSV or other format.
  module Exporters
    include Fox
    # GUI to export Purchase and Sell instances to CSV.
    class CSVInventoryExporter < CSVExporter
      def initialize(...)
        super(...)

        calendars = FXHorizontalFrame.new @foptions

        cal1 = FXVerticalFrame.new calendars
        FXLabel.new cal1, 'Exportar desde:'
        @ffrom_cal = FXCalendar.new cal1
        @ffrom_label = FXLabel.new cal1, 'Haga clic en una fecha.'

        cal2 = FXVerticalFrame.new calendars
        FXLabel.new cal2, 'Exportar hasta:'
        @fto_cal = FXCalendar.new cal2
        @fto_label = FXLabel.new cal2, 'Haga clic en una fecha.'

        @lblwarning = FXLabel.new @foptions, ''
        @lblwarning.textColor = FXColor::Red
        @lblwarning.font = FXFont.new getApp, 'Courier,100,normal,italic'

        enable_btnsave_if_ready

        self.assign_handlers
      end

      protected

      def enable_btnsave?
        from = @ffrom_cal.selected
        to = @fto_cal.selected
        !@txtsave.text.empty? && !from.nil? && !to.nil? && warning_text == ''
      end

      # Enable the @btnsave button if the data is ready
      #
      # If a data is missing, disable it.
      def enable_btnsave_if_ready
        if enable_btnsave?
          @btnsave.enable
        else
          @btnsave.disable
        end
      end

      def warning_text
        str = ''

        from = @ffrom_cal.selected
        to = @fto_cal.selected

        return '' if from.nil? || to.nil?

        str += '¡No se puede exportar más de 60 días!' if too_much_time?
        str += '¡La fecha inicial ("Exportar desde") no puede ser posterior a la fecha final ("Exportar hasta")!' \
          if from > to

        str
      end

      def update_widgets
        super

        enable_btnsave_if_ready

        @lblwarning.text = warning_text
      end

      def on_from_cal_clicked(_sender, _sel, data)
        date_str = data.strftime '%D'
        @ffrom_label.text = "Seleccionado: #{date_str}"
        update_widgets
      end

      def on_to_cal_clicked(_sender, _sel, data)
        date_str = data.strftime '%D'
        @fto_label.text = "Seleccionado: #{date_str}"
        update_widgets
      end

      def assign_handlers
        super

        @ffrom_cal.connect SEL_COMMAND, method(:on_from_cal_clicked)
        @fto_cal.connect SEL_COMMAND, method(:on_to_cal_clicked)
      end

      def do_save
        puts "Writing #{@txtsave.text} CSV file."
        exporter = create_exporter
        return if exporter.too_much_time?

        exporter.to_file @txtsave.text
      end

      # Is the date range over the time limit?
      #
      # @return [Boolean] true if the range is over the limit.
      def too_much_time?
        raise 'Method must be reimplemented in subclass!'
      end

      # Create the Exporter::InventoryExporter subclass instance.
      #
      # @return [InventoryExporter] The instance.
      def create_exporter
        raise 'Method must be reimplemented in subclass!'
      end
    end
  end
end
