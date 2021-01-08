# Copyright 2020 Christian Gimenez
# 
# wstock.rb
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

require_relative 'wproduct_list'

module GUI
  class WStock < WProductList
    def initialize(...)
      super(...)

      @wproduct = WProduct.new @fright, "Nuevo Producto", :opts => FRAME_NORMAL | LAYOUT_FILL_X
      
      @btnnew = FXButton.new @fright, "Nuevo producto", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL
      @btnnew.connect SEL_COMMAND do |sender, sel, data|
        p = @wproduct.product
        p.save

        add_product p unless @wpf.stock.member? p

        reset_input
        update_widgets
      end
      
      update_widgets
    end

    def add_product(product)
      @wpf.add product
      update_widgets
    end
    
    protected
    
    def reset_input
      @wproduct.reset
    end
    
  end
end
