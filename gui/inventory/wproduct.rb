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
  module Inventory
    include Fox
    # Product widget
    #
    # Display and edit a product instance.
    class WProduct < FXGroupBox
      def initialize(...)
        super(...)

        @actions = { on_data_entered: nil }
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

      def on(action, &block)
        @actions[action] = block
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

      def reset(with_focus: false)
        @product = nil
        update_widgets
        @txtname.setFocus if with_focus
      end

      def editing?
        !@product.nil?
      end

      def new_product
        Models::Product.create name: @txtname.text,
                       code: @txtcode.text,
                       stock: @txtstock.text.to_i,
                       unitary_cost: @txtcost.text.to_f
      end

      #  Return the warning text depending on the editing product and the cost inputted.
      #
      # @param cost [Float] (Optional). The cost to consider when creating the
      #   warning text. If absent, the use the current @product cost.
      # @return '' [String] When the form is not editing a product.
      # @return [String] The warnings of using that cost.
      def warning_text(cost=nil)
        return '' unless editing?

        cost = @product.unitary_cost if cost.nil?
        last_price = @product.last_purchased_price

        if cost < last_price
          "Advertencia: El precio de venta es\nmás barato que el precio de compra."
        elsif cost > last_price + last_price * 0.5
          "Advertencia: El precio de venta supera\nel 50% de aumento al del precio de compra."
        else
          ''
        end
      end

      private

      def on_txtcost_changed(_sender, _sel, data)
        return unless editing?

        @lblwarnings.text = warning_text data.to_f
      end

      def on_txtname_enter(...)
        return if @txtname.text.empty?

        @txtcode.setFocus
        @txtcode.selectAll
      end

      def on_txtcode_enter(...)
        return if @txtcode.text.empty?

        @txtstock.setFocus
        @txtstock.selectAll
      end

      def on_txtstock_enter(...)
        return if @txtstock.text.empty?

        @txtcost.setFocus
        @txtcost.selectAll
      end

      # What to do when user press enter on txtcost.
      #
      # If a text is entered, it call the on_data_entered action without parameters.
      def on_txtcost_enter(...)
        return if @txtcost.text.empty?

        @actions[:on_data_entered]&.call
      end

      def assign_handlers
        @txtcost.connect SEL_CHANGED, method(:on_txtcost_changed)
        # Sequence of ENTER presses for easy input.
        @txtname.connect SEL_COMMAND, method(:on_txtname_enter)
        @txtcode.connect SEL_COMMAND, method(:on_txtcode_enter)
        @txtstock.connect SEL_COMMAND, method(:on_txtstock_enter)
        @txtcost.connect SEL_COMMAND, method(:on_txtcost_enter)
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
        @lblwarnings.text = warning_text
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
end
