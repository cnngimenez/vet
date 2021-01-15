# Copyright 2021 Christian Gimenez
#
# wpurchaseslist.rb
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

require_relative '../../models'
require_relative 'winventorylist'
require_relative 'wpurchase_edit'

module GUI
  module Inventory
    # List all Purchase instances (items bought) filtered by a particular date.
    class WPurchasesList < WInventoryList

      def initialize(...)
        super(...)

        @wpurredit = WPurchaseEdit.new @flistframe, 'Editar Compra', opts: FRAME_NORMAL | LAYOUT_FILL_Y

        assign_handlers
      end
      
      protected
      
      def from_date(date)
        Models::Purchase.between_dates  from: date, to: date + 1.day
      end

      def on_flist_doubleclicked(_sender, _sel, data)
        obj = @lstobjs[data]
        @wpurredit.purchase = obj
      end

      def on_wpurredit_save
        @wpurredit.enable false
        update_widgets
      end
      
      def assign_handlers
        super

        @wpurredit.on :on_save, method(:on_wpurredit_save)
        @flist.connect SEL_DOUBLECLICKED, method(:on_flist_doubleclicked)        
      end
    end
  end
end
