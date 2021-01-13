# Copyright 2021 Christian Gimenez
#
# winventorylist.rb
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

module GUI
  # Class to show a list of sells and purchases.
  class WInventoryList < FXMDIChild
    def initialize(...)
      super(...)

      fv = FXVerticalFrame.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @flbl_cal = FXLabel.new fv, 'Fecha a mostrar: '
      @fcal = FXCalendar.new fv

      @flistframe = FXHorizontalFrame.new fv, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @flist = FXList.new @flistframe, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL

      @date = nil
      @lstobjs = []

      assign_handlers
      set_date Time.now # This calls update_widgets too.
    end

    attr_reader :date
    
    # @param date [Time]
    def set_date (date)
      @date = date
      @lstobjs = from_date @date
      update_widgets
    end
    
    protected

    # Return all the objects to be listed that where sold or purchased at the given date.
    #
    # @param date [Time]
    def from_date(date)
      raise 'This method must be reimplemented by the subclass!'
    end
    
    def update_widgets
      @flbl_cal.text = "Fecha a mostrar: #{@date.strftime '%D'}"

      @flist.clearItems
      @lstobjs.each do |obj|
        @flist.appendItem obj.to_s
      end
    end

    def on_fcal_clicked(_sender, _sel, data)
      set_date data
    end
    
    def assign_handlers
      @fcal.connect SEL_COMMAND, method(:on_fcal_clicked)
      
      connect SEL_CLOSE do
        hide
        1 # Avoid deleting when closing.
      end
    end
    
  end
end
