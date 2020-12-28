# coding: utf-8
# Copyright 2020 Christian Gimenez
# 
# wbill.rb
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
  # A bill like form.
  #
  # This form allows the user to enter several items to purchase or sell.
  #
  class WBill < WProductList
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
      
      @btnaction = FXButton.new @fright, "Acción", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL
      @btnaction.connect SEL_COMMAND do |sender, sel, data|
        purr = create_obj  amount: @txtcant.text.to_i,
                           unitary_cost: @txtprice.text.to_f,
                           desc: @txtdesc.text,
                           product: selected_product
        add_obj purr

        reset_input
      end

      @lst_objs = Array.new
      @flst_items = FXList.new @fmain, :opts => LAYOUT_FILL_X | LIST_NORMAL
      @lbltotal = FXLabel.new @fmain, "Total: "
      @btnsave = FXButton.new @fmain, "Guardar", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL
      @btnsave.connect SEL_SELECTED do |sender, sel, data|
        confirm_save
      end
      
      @wpf.on :on_select do |sender, sel, data|
        enable_purchase
      end
      @wpf.on :on_deselect do |sender, sel, data|
        enable_purchase FALSE
      end

      reset_input
      update_widgets
    end

    def add_obj(purr)
      @lst_objs.push purr
      update_widgets
    end

    def confirm_save
      @lst_objs.each do |purr|
        purr.save
        purr.product.stock += purr.amount
        purr.product.save        
      end
      hide
    end
    
    protected

    # This is used to create an instance of the Purchase or Sell class.
    #
    # This method must be reimplemented by the subclass. Do not use super.
    #
    # @param data [Hash] Information obtained from the form. Keys are: amount,
    #   unitary_cost, desc and product.
    # @return [Object]
    def create_obj(data)
      raise "WBill#create_obj must be implemented by the subclass"
    end
    
    def enable_purchase(enable=TRUE)
      if enable
        @txtdesc.enable
        @txtprice.enable
        @txtcant.enable
        @btnaction.enable
      else
        @txtdesc.disable
        @txtcant.disable
        @txtprice.disable
        @btnaction.disable
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
      
      @flst_items.clearItems
      total = 0
      @lst_objs.each do |purr|
        @flst_items.appendItem purr.to_s
        total += purr.total
      end
      @lbltotal.text = "Total: #{total}"
    end
    
  end # WPurchase
end # GUI
