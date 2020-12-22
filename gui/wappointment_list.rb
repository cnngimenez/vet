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

require_relative 'wappointment'
require_relative '../models'
include Models

module GUI
  # Appointment widget
  class WAppointment_List < FXVerticalFrame
    def initialize(...)
      super(...)

      @lst = Array.new

      @fxh1 = FXHorizontalFrame.new self,
                                    :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @cal = FXCalendar.new @fxh1
      @cal.connect SEL_COMMAND do |sender, sel, data|
        set_date data
      end
      
      @fxv1 = FXVerticalFrame.new @fxh1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @fxdate = FXLabel.new @fxv1, "Turnos para hoy"
      @fxlist = FXList.new @fxv1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y

      @wap = WAppointment.new self, "Nuevo Turno",
                              :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      
      @fxbtn = FXButton.new self, "Nuevo Turno",
                            :opts => LAYOUT_CENTER_X | BUTTON_NORMAL 
      @fxbtn.connect SEL_COMMAND do |sender, sel, data|
        ap = @wap.new_appointment
        ap.save
        add_appointment ap
        
        reset_input 
      end

      update_widgets
    end

    def set_date(date)
      @fxdate.text = "Turnos para " + date.strftime("%D")
      @lst = Appointment.filter_by_date date
      update_widgets
    end
    
    def reset_input
      @wap.reset
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
