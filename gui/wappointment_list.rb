# coding: utf-8
# Copyright 2020 Christian Gimenez
# 
# wappointment_list.rb
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
  # Appointment widget
  class WAppointment_List < FXVerticalFrame
    def initialize(...)
      super(...)

      @lst = Array.new
      
      @cal = FXCalendar.new self      
      @fxlist = FXList.new self, :opts => LAYOUT_FILL_X
      
      @fxtxt = FXTextField.new self, 50, :opts => LAYOUT_FILL_X
      @fxtxt.text = "Título"
      @fxtxt.helpText = "Título del turno"
      @fxtxt.tipText= "Título del turno"

      @wtime = WTimeRange.new self

      @fxdesc = FXText.new self, :opts => LAYOUT_FILL_X
      
      @fxbtn = FXButton.new self, "Nuevo Turno", :opts => LAYOUT_FILL_X
      @fxbtn.connect SEL_COMMAND do |sender, sel, data|
        ap = Appointment.create title: @fxtxt.text,
                                time_start: @wtime.time_start.to_i,
                                time_end: @wtime.time_end.to_i,
                                desc: @fxdesc.text
        ap.save
        add_appointment ap
        
        reset_input
      end

      update_widgets
    end

    def reset_input
      @fxtxt.text = ""
      @fxdesc.text = ""
      @wtime.reset
    end

    def lst=(lst_appointments)
      @lst = lst_appointments
      update_widgets
    end

    def lst
      return @lst
    end
    
    def add_appointment(appointment)
      @lst.push appointment
      update_widgets
    end

    private
    
    def update_widgets
      @fxlist.clearItems
      @lst.each do |ap|
        @fxlist.appendItem ap.to_s
      end      
    end   
  end # WAppointment_List
end
