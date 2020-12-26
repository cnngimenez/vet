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
require_relative 'wproduct_filter'

module GUI
  class WProductList < FXMainWindow
    def initialize(...)
      super(...)

      @fmain = FXVerticalFrame.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y

      @ftop = FXHorizontalFrame.new @fmain, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @wpf = WProductFilter.new @ftop, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @fright = FXVerticalFrame.new @ftop

      self.connect SEL_CLOSE do |sender, sel,data|
        self.visible=FALSE
        1 # This avoids deleting itself when closing
      end
    end

    def update_stock
      @wpf.update_stock
    end
    
    def stock=(new_stock)
      @wpf.stock = new_stock
      update_widgets
    end

    def stock
      return @wpf.stock
    end

    def selected_product
      return @wpf.selected_product
    end

    protected
    
    def reset_input
      @wpf.reset_input
    end
    
    def update_widgets
      @wpf.update_widgets
    end
  end
end
