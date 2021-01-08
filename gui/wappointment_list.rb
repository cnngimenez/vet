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
      super mdiclient, 'Turnos', nil, nil, 0, 10, 10, 700, 500

      @lst = []

      fx1 = FXVerticalFrame.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y

      # Calendar frame
      fxh1 = FXHorizontalFrame.new fx1, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @fcal = FXCalendar.new fxh1

      # List frame
      fxv1 = FXVerticalFrame.new fxh1, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      # +- Buttons on the top of the list
      f2 = FXHorizontalFrame.new fxv1, opts: LAYOUT_FILL_X
      @btnyesterday = FXButton.new f2, 'Ayer'
      @btntoday = FXButton.new f2, 'Hoy'
      @btntomorrow = FXButton.new f2, 'Mañana'
      # +- List
      @fxdate = FXLabel.new fxv1, 'Turnos para hoy'
      @fxlist = FXList.new fxv1, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL

      @wap = WAppointment.new fx1, 'Nuevo Turno', opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NORMAL
      @fxbtn = FXButton.new fx1, 'Nuevo Turno', opts: LAYOUT_CENTER_X | BUTTON_NORMAL

      assign_handlers
      set_date Time.now # Also calls update_widgets
    end

    def edit_appointment_num(position)
      edit_appointment @lst[position]
    end

    def edit_appointment(appointment)
      return if appointment.nil?

      @wap.edit appointment
      @fxbtn.text = 'Guardar Turno'
    end

    def set_date(date)
      @fxdate.text = 'Turnos para ' + date.strftime('%D')
      @lst = Appointment.filter_by_date date
      update_widgets
    end

    def reset_input
      @wap.reset
      @fxbtn.text = 'Nuevo Turno'
    end

    def lst=(lst_appointments)
      @lst = lst_appointments
      update_widgets
    end

    attr_reader :lst

    def add_appointment(appointment)
      @lst.push appointment
      update_widgets
    end

    private

    def assign_handlers
      @fcal.connect SEL_COMMAND do |_sender, _sel, data|
        set_date data
      end
      @btnyesterday.connect SEL_COMMAND do |_sender, _sel, _data|
        set_date Time.now - 86_400 # = 1 day
      end
      @btntoday.connect SEL_COMMAND do |_sender, _sel, _data|
        set_date Time.now
      end
      @btntomorrow.connect SEL_COMMAND do |_sender, _sel, _data|
        set_date Time.now + 86_400 # = 1 day
      end
      @fxlist.connect SEL_DOUBLECLICKED do |_sender, _sel, data|
        edit_appointment_num data
      end
      @fxbtn.connect SEL_COMMAND do |_sender, _sel, _data|
        ap = @wap.appointment
        ap.save

        add_appointment ap unless @lst.member? ap

        reset_input
        update_widgets
      end

      # Avoid deleting when closing
      connect SEL_CLOSE do
        hide
        1
      end
    end

    def update_widgets
      @fxlist.clearItems
      @lst.each do |ap|
        @fxlist.appendItem ap.to_s
      end
    end
  end
end
