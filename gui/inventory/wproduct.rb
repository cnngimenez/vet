# coding: utf-8
# Copyright 2020 Christian Gimenez
#
# wproduct.rb
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

require 'fox16'
require_relative '../../models'

# User interface module.
module GUI
  include Fox
  include Models
  # Product widget
  #
  # Display and edit a product instance.
  class WProduct < FXGroupBox
    def initialize(...)
      super(...)

      @product = nil

      @lblname = FXLabel.new self, 'Nombre:'
      @txtname = FXTextField.new self, 50, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL
      @lblcode = FXLabel.new self, 'Código:'
      @txtcode = FXTextField.new self, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL
      @lblstock = FXLabel.new self, 'Stock inicial:'
      @txtstock = FXTextField.new self, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_INTEGER
      @lblcost = FXLabel.new self, 'Precio unitario de venta:'
      @txtcost = FXTextField.new self, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_REAL
      @lblpurchased = FXLabel.new self, '(Precio de última compra: $0.0)'
      @lblwarnings = FXLabel.new self, ''
      @lblwarnings.textColor = FXColor::Red
      @lblwarnings.font = FXFont.new getApp, 'Courier,100,normal,italic'

      assign_handlers
      update_widgets
    end

    def product
      if @product.nil?
        new_product
      else
        update_data
        @product
      end
    end

    def edit(product)
      @product = product
      update_widgets
    end

    def reset
      @product = nil
      update_widgets
    end

    def editing?
      !@product.nil?
    end

    def new_product
      Product.create name: @txtname.text,
                     code: @txtcode.text,
                     stock: @txtstock.text.to_i,
                     unitary_cost: @txtcost.text.to_f
    end

    private

    def on_txtcost_changed(_sender, _sel, data)
      return unless editing?

      cost = data.to_f
      last_price = @product.last_purchased_price

      if cost < last_price
        @lblwarnings.text = "Advertencia: El precio de venta es\nmás barato que el precio de compra."
      elsif cost > last_price + last_price * 0.5
        @lblwarnings.text = "Advertencia: El precio de venta supera\nel 50% de aumento al del precio de compra."
      else
        @lblwarnings.text = ''
      end
    end

    def assign_handlers
      @txtcost.connect SEL_CHANGED, method(:on_txtcost_changed)
    end

    def update_widgets
      if @product.nil?
        @txtname.text = ''
        @txtcode.text = ''
        @txtstock.text = '0'
        @txtcost.text = '1.0'
        @lblpurchased.text = '(Nuevo producto)'
      else
        @txtname.text = @product.name
        @txtcode.text = @product.code
        @txtstock.text = @product.stock.to_s
        @txtcost.text = @product.unitary_cost.to_s
        @lblpurchased.text = "(Precio de ultima compra: $#{@product.last_purchased_price})"
      end
    end

    def update_data
      return if @product.nil?

      @product.name = @txtname.text
      @product.code = @txtcode.text
      @product.stock = @txtstock.text.to_i
      @product.unitary_cost = @txtcost.text.to_f
    end
  end
end
