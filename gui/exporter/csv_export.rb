# coding: utf-8
# Copyright 2021 Christian Gimenez
#
# csv_export.rb
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

# User Interface module
module GUI
  include Fox
  include Exporters
  # The CSV Exporter Window
  #
  # Show export options to the user.
  class CSVExporter < FXMainWindow
    def initialize(...)
      super(...)

      f1 = FXVerticalFrame.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y

      f2 = FXHorizontalFrame.new f1, opts: LAYOUT_FILL_X
      @txtsave = FXTextField.new f2, 50, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_READONLY
      @btnfile = FXButton.new f2, 'Seleccionar archivo'

      @btnsave = FXButton.new f1, 'Exportar'

      assign_handlers
    end

    def show
      super
      getApp.runModalFor self
    end

    def hide
      getApp.stopModal
      super
    end

    private

    def on_btnfile_clicked(...)
      filepath = FXFileDialog.getSaveFilename self, 'Archivo CSV a Exportar', '~/',
                                              "Archivos CSV (*.csv)\nTodos los archivos (*)"

      return if filepath.nil?

      filepath += '.csv' unless filepath.end_with? '.csv'
      @txtsave.text = filepath
    end

    def do_save
      puts "Writing #{@txtsave.text} CSV file."
      exporter = CSVExporters::ProductExporter.new
      exporter.to_file @txtsave.text
    end

    def on_btnsave_clicked(...)
      return if @txtsave.text.empty?

      if File.exist? @txtsave.text
        yesno = FXMessageBox.question self,
                                      MBOX_YES_NO_CANCEL,
                                      '¿Sobreescribir archivo?',
                                      "El archivo #{@txtsave.text} ya existe. ¿Desea sobreescribirlo?"
        case yesno
        when MBOX_CLICKED_YES
          do_save
        when MBOX_CLICKED_NO
          return
        end
      else
        do_save
      end

      hide
    end

    def assign_handlers
      @btnfile.connect SEL_COMMAND, method(:on_btnfile_clicked)
      @btnsave.connect SEL_COMMAND, method(:on_btnsave_clicked)
      connect SEL_CLOSE do
        hide
        1 # do not delete the window!
      end
    end
  end
end
