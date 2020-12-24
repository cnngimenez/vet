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

require_relative 'wproduct'

module GUI
  class WStock < FXMainWindow
    def initialize(...)
      super(...)

      @stock = Array.new

      @f1 = FXVerticalFrame.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y

      @flist = FXList.new @f1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL

      @wproduct = WProduct.new @f1, "Nuevo Producto",
                               :opts => LAYOUT_FILL_X | FRAME_NORMAL
      
      @btnnew = FXButton.new @f1, "Nuevo producto"
      @btnnew.connect SEL_COMMAND do |sender, sel, data|
        p = @wproduct.product
        p.save

        add_product p unless @stock.member? p

        reset_input
        update_widgets
      end
      
      update_widgets
    end

    def stock=(new_stock)
      @stock = new_stock
      update_widgets
    end

    def stock
      return stock
    end

    def add_product(product)
      @stock.push product
      update_widgets
    end
    
    private

    def reset_input
      @wproduct.reset
    end
    
    def update_widgets
      @flist.clearItems
      @stock.each do |product|
        @flist.appendItem product.to_s
      end
    end
  end
end
