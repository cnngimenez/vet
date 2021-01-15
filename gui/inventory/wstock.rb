# coding: utf-8
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

# frozen_string_literal: true

require 'fox16'
require_relative '../../models'
require_relative 'wproduct_list'
require_relative '../common_widgets'

# User interface module
module GUI
  module Inventory
    include Fox
    include Models

    # The Stock Window
    #
    # Display and manage the stocked products.
    class WStock < WProductList
      def initialize(...)
        super(...)

        CommonWidgets::WTipButton.new @ftips, self.parent, 'wstock'
        @wproduct = WProduct.new @fright, 'Producto', opts: FRAME_NORMAL | LAYOUT_FILL_X
        @btnnew = FXButton.new @fright, 'Nuevo producto', opts: LAYOUT_CENTER_X | BUTTON_NORMAL
        @lblpurchased = FXLabel.new @fright, 'Últimas 10 compras a vendedor:'
        @lstpurchased = FXList.new @fright, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL
        @lblsold = FXLabel.new @fright, 'Últimas 10 ventas a clientes:'
        @lstsold = FXList.new @fright, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL

        assign_handlers
        update_widgets
      end

      def add_product(product)
        puts product.errors.objects.to_s unless product.valid?
        return false unless product.valid?
        puts "Saving product"
        product.save
        @wpf.add_product product
        update_widgets
      end

      protected

      def update_widgets
        super
        @btnnew.text = "Nuevo producto"
        
        return unless @wproduct.editing?

        product = @wproduct.product

        @lstpurchased.clearItems
        product.purchases.limit(10).order('date desc').each do |purr|
          @lstpurchased.appendItem purr.to_s
        end
        @lstsold.clearItems
        product.sells.limit(10).order('date desc').each do |sell|
          @lstsold.appendItem sell.to_s
        end
        @btnnew.text = "Guardar"
      end

      def reset_input
        @wproduct.reset with_focus: true
      end

      private

      def save_product
        p = @wproduct.product
        add_product p
        reset_input
      end
      
      def assign_handlers
        # Sequence of ENTERS
        @wproduct.on :on_data_entered do
          @btnnew.setFocus
        end
        @btnnew.connect SEL_KEYPRESS do |_sender, _sel, data|
          save_product if data.text = "\n"
        end
        
        @wpf.on :on_double_click do |product|
          wpf_double_clicked product
        end
        @btnnew.connect SEL_COMMAND do |_sender, _sel, _data|
          save_product
        end
      end

      def wpf_double_clicked(product)
        @wproduct.edit product
        update_widgets
      end
    end
  end
end
