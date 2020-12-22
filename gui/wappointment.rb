# coding: utf-8
# Copyright 2020 Christian Gimenez
# 
# wappointment.rb
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

require 'fox16'
include Fox

require_relative 'wtimerange'
require_relative '../models'
include Models


module GUI

  ##
  # Widget to display and edit an Appointment instance
  #
  class WAppointment < FXVerticalFrame
    def initialize(...)
      super(...)
      
      @fxtitle = FXTextField.new self, 50
      @fxtitle.text = "Título"
      @fxtitle.helpText = "Título del turno"
      @fxtitle.tipText= "Título del turno"

      @wtime = WTimeRange.new self, :opts => LAYOUT_CENTER_X

      @fxdesc = FXText.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      
    end

    # Reset the widget with blank information.
    def reset
      @fxtitle.text = ""
      @fxdesc.text = ""
      @wtime.reset
    end

    # Get a new appointment model.
    #
    # The model is created with the user input. It is not saved on the DB.
    #
    # @return [Model::Appointment] A new appointment instance.
    def new_appointment
      Appointment.create title: @fxtitle.text,
                         time_start: @wtime.time_start.to_i,
                         time_end: @wtime.time_end.to_i,
                         desc: @fxdesc.text
    end
    
  end # WAppointment
end # GUI
