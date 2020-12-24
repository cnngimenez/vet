# Copyright 2020 Christian Gimenez
# 
# wproduct_list.rb
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

require_relative '../../models'
include Models

require_relative 'wproduct'

module GUI
  class WProductList < FXMainWindow
    def initialize(...)
      super(...)

      @stock = Array.new

      @fmain = FXVerticalFrame.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y

      @ftop = FXHorizontalFrame.new @fmain, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @flist = FXList.new @ftop, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL
      @fright = FXVerticalFrame.new @ftop, :opts => LAYOUT_FILL_X
    end

    def stock=(new_stock)
      @stock = new_stock
      update_widgets
    end

    def stock
      return stock
    end

    protected
    
    def reset_input
    end
    
    def update_widgets
      @flist.clearItems
      @stock.each do |product|
        @flist.appendItem product.to_s
      end
    end
  end
end
