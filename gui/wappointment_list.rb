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
  class WAppointment_List < FXMDIChild
    def initialize(mdiclient)
      super mdiclient, 'Turnos', nil, nil, 0, 10, 10, 700, 700

      @lst = []
      
      @fxh1 = FXHorizontalFrame.new self,
                                    :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @cal = FXCalendar.new @fxh1
      @cal.connect SEL_COMMAND do |sender, sel, data|
        set_date data
      end
      
      @fxv1 = FXVerticalFrame.new @fxh1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y

      @f2 = FXHorizontalFrame.new @fxv1, :opts => LAYOUT_FILL_X
      @btnyesterday = FXButton.new @f2, "Ayer"
      @btnyesterday.connect SEL_COMMAND do |sender, sel, data|
        set_date Time.now - 86400 # = 1 day
      end
      @btntoday = FXButton.new @f2, "Hoy"
      @btntoday.connect SEL_COMMAND do |sender, sel, data|
        set_date Time.now
      end
      @btntomorrow = FXButton.new @f2, "Mañana"
      @btntomorrow.connect SEL_COMMAND do |sender, sel, data|
        set_date Time.now + 86400 # = 1 day
      end
      
      @fxdate = FXLabel.new @fxv1, "Turnos para hoy"
      @fxlist = FXList.new @fxv1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL
      @fxlist.connect SEL_DOUBLECLICKED do |sender, sel, data|
        edit_appointment_num data
      end

      @wap = WAppointment.new self, "Nuevo Turno",
                              :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NORMAL
      
      @fxbtn = FXButton.new self, "Nuevo Turno",
                            :opts => LAYOUT_CENTER_X | BUTTON_NORMAL 
      @fxbtn.connect SEL_COMMAND do |sender, sel, data|
        ap = @wap.appointment
        ap.save
        
        add_appointment ap unless @lst.member? ap
                
        reset_input
        update_widgets
      end

      # Avoid deleting when closing
      self.connect SEL_CLOSE do
        hide
        1
      end
      
      set_date Time.now # Also calls update_widgets
    end

    def edit_appointment_num(position)
      edit_appointment @lst[position]
    end

    def edit_appointment(appointment)
      return if appointment.nil?

      @wap.edit appointment
      @fxbtn.text = "Guardar Turno"
    end
    
    def set_date(date)
      @fxdate.text = "Turnos para " + date.strftime("%D")
      @lst = Appointment.filter_by_date date
      update_widgets
    end
    
    def reset_input
      @wap.reset
      @fxbtn.text = "Nuevo Turno"
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
