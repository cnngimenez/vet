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
  class WAppointment < FXGroupBox
    def initialize(...)
      super(...)

      # The appointment instance to edit
      @ap = nil
      
      @lbltitle = FXLabel.new self, "Título"
      @fxtitle = FXTextField.new self, 50, :opts => LAYOUT_FILL_X | TEXTFIELD_NORMAL
      @fxtitle.helpText = "Título del turno"
      @fxtitle.tipText= "Título del turno"

      @lbltime = FXLabel.new self, "Hora"
      @wtime = WTimeRange.new self, :opts => LAYOUT_CENTER_X

      @lbldesc = FXLabel.new self, "Descripción"
      @fxdesc = FXText.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
    end
   
    # Set the edit mode and use the widget to edit the given appointment.
    #
    # @param appointment [Models::Appointment] The instance to edit. If nil,
    # then reset the data (same as #reset).
    def edit(appointment)
      @ap = appointment

      update_widgets
    end

    def ap
      if @ap.nil?
        return new_appointment
      else
        update_data
        return @ap
      end
    end

    alias appointment ap
    
    # Reset the widget with blank information.
    def reset
      @ap = nil
      update_widgets
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
    
    private

    def update_widgets
      if @ap.nil?
        @fxtitle.text = ""
        @fxdesc.text = ""
        @wtime.reset
      else
        @fxtitle.text = @ap.title
        @fxdesc.text = @ap.desc
        @wtime.range = [@ap.t_time_start, @ap.t_time_end ]
      end
    end

    def update_data
      return if @ap.nil?
      @ap.title = @fxtitle.text
      @ap.time_start=@wtime.time_start.to_i
      @ap.time_end=@wtime.time_end.to_i
      @ap.desc = @fxdesc.text
    end
    
  end # WAppointment
end # GUI
