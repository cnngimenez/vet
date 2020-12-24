# coding: utf-8
# Copyright 2020 Christian Gimenez
# 
# wpurchase.rb
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
  class WPurchase < WProductList
    def initialize(...)
      super(...)

      @stock = Product.all.to_a

      @lblcant = FXLabel.new @fright, "Cantidad:"
      @txtcant = FXTextField.new @fright, 4, :opts => LAYOUT_FILL_X | TEXTFIELD_NORMAL |
                                                     TEXTFIELD_INTEGER
      @lblprice = FXLabel.new @fright, "Precio unitario:"
      @txtprice = FXTextField.new @fright, 4, :opts => LAYOUT_FILL_X | TEXTFIELD_NORMAL |
                                                      TEXTFIELD_REAL
      @lblcant = FXLabel.new @fright, "Descripción:"
      @txtdesc = FXText.new @fright, :opts => LAYOUT_FILL_X
      
      @btnpurchase = FXButton.new @fright, "Compra", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL
      @btnpurchase.connect SEL_COMMAND do |sender, sel, data|
        purr = Purchase.create amount: @txtcant.text.to_i,
                               unitary_cost: @txtprice.text.to_f,
                               desc: @txtdesc.text,
                               product: selected_product
        add_purchase purr

        reset_input
      end

      @lst_purchases = Array.new
      @flst_purchased = FXList.new @fmain, :opts => LAYOUT_FILL_X | LIST_NORMAL
      @lbltotal = FXLabel.new @fmain, "Total: "

      @flist.connect SEL_SELECTED do |sender, sel, data|
        enable_purchase
      end
      @flist.connect SEL_DESELECTED do |sender, sel, data|
        enable_purchase FALSE
      end

      reset_input
      update_widgets
    end

    def add_purchase(purr)
      @lst_purchases.push purr
      update_widgets
    end
    
    protected
    
    def enable_purchase(enable=TRUE)
      if enable
        @txtdesc.enable
        @txtprice.enable
        @txtcant.enable
        @btnpurchase.enable
      else
        @txtdesc.disable
        @txtcant.disable
        @txtprice.disable
        @btnpurchase.disable
      end
    end

    def reset_input
      super
      @txtdesc.text = ""
      @txtcant.text = "1"
      @txtprice.text = "1.0"
      enable_purchase FALSE
    end

    def update_widgets
      super
      
      @flst_purchased.clearItems
      total = 0
      @lst_purchases.each do |purr|
        @flst_purchased.appendItem purr.to_s
        total += purr.total
      end
      @lbltotal.text = "Total: #{total}"
    end
    
  end # WPurchase
end # GUI
