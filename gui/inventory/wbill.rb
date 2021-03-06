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

# frozen_string_literal: true

require 'fox16'
require_relative '../../models'
require_relative 'wproduct_list'

# User interface module
module GUI
  module Inventory
    include Fox
    include Models
    # A bill like form.
    #
    # This form allows the user to enter several items to purchase or sell.
    #
    class WBill < WProductList
      def initialize(...)
        super(...)

        @stock = Models::Product.all.to_a

        @lblproduct = FXLabel.new @fright, 'Producto:'
        @lblcant = FXLabel.new @fright, 'Cantidad:'
        @txtcant = FXTextField.new @fright, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_INTEGER
        @lblprice = FXLabel.new @fright, 'Precio unitario:'
        @txtprice = FXTextField.new @fright, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_REAL
        @lblcant = FXLabel.new @fright, 'Descripción:'
        @txtdesc = FXText.new @fright, opts: LAYOUT_FILL_X
        @btnaction = FXButton.new @fright, 'Acción', opts: LAYOUT_CENTER_X | BUTTON_NORMAL

        @lst_objs = []
        @flst_items = FXList.new @fmain, opts: LAYOUT_FILL_X | LIST_NORMAL
        @lbltotal = FXLabel.new @fmain, 'Total: '

        @fbtns = FXHorizontalFrame.new @fmain, opts: LAYOUT_FILL_X
        @btnsave = FXButton.new @fbtns, 'Guardar', opts: LAYOUT_CENTER_X | BUTTON_NORMAL
        @btncancel = FXButton.new @fbtns, 'Cancelar', opts: LAYOUT_CENTER_X | BUTTON_NORMAL

        assign_handlers
        reset_input
        update_widgets
      end

      def add_obj(purr)
        @lst_objs.push purr
        update_widgets
      end

      def confirm_save
        @lst_objs.each do |purr|
          puts purr.errors.objects.to_s unless purr.valid?
          purr.save
          purr.product.stock += purr.amount
          purr.product.save
        end
        reset_input
        @lst_objs = []
        close TRUE
      end

      def cancel
        reset_input
        @lst_objs = []
        close TRUE
      end

      protected

      # This is used to create an instance of the Purchase or Sell class.
      #
      # This method must be reimplemented by the subclass. Do not use super.
      #
      # @param data [Hash] Information obtained from the form. Keys are: amount,
      #   unitary_cost, desc and product.
      # @return [Object]
      def create_obj(_data)
        raise 'WBill#create_obj must be implemented by the subclass'
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
        @txtdesc.text = ''
        @txtcant.text = '1'
        @txtprice.text = '1.0'
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

      private

      def assign_handlers
        @btnaction.connect SEL_COMMAND do |_sender, _sel, _data|
          purr = create_obj  amount: @txtcant.text.to_i,
                             unitary_cost: @txtprice.text.to_f,
                             desc: @txtdesc.text,
                             product: selected_product
          purr.t_date = Time.now
          add_obj purr

          reset_input
        end
        @btnsave.connect SEL_COMMAND do |_sender, _sel, _data|
          confirm_save
        end
        @btncancel.connect SEL_COMMAND do |_sender, _sel, _data|
          cancel
        end
        @wpf.on :on_select do |_sender, _sel, _data|
          product = @wpf.selected_product
          if product.unitary_cost.nil?
            cost = 1.0
          else
            cost = product.unitary_cost
          end
          @txtprice.text = cost.to_s
          @lblproduct.text = "Producto: #{product.name}"
          enable_purchase
        end
        @wpf.on :on_deselect do |_sender, _sel, _data|
          enable_purchase FALSE
        end
      end
    end
  end
end
