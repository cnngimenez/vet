# coding: utf-8
# Copyright 2021 Christian Gimenez
#
# wpurchase_edit.rb
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

module GUI
  module Inventory
    class WPurchaseEdit < FXGroupBox
      def initialize(...)
        super(...)

        @purchase = nil
        @actions = { on_save: nil }

        fv1 = FXVerticalFrame.new self, LAYOUT_FILL_X | LAYOUT_FILL_Y
        @lblproduct = FXLabel.new fv1, 'Producto:'
        @lblcant = FXLabel.new fv1, 'Cantidad:'
        @txtcant = FXTextField.new fv1, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_INTEGER
        @lblprice = FXLabel.new fv1, 'Precio unitario:'
        @txtprice = FXTextField.new fv1, 4, opts: LAYOUT_FILL_X | TEXTFIELD_NORMAL | TEXTFIELD_REAL
        @lblcant = FXLabel.new fv1, 'Descripción:'
        @txtdesc = FXText.new fv1, opts: LAYOUT_FILL_X
        @btnsave = FXButton.new fv1, 'Guardar', opts: LAYOUT_CENTER_X | BUTTON_NORMAL

        assign_handlers
        reset_input
        update_widgets
      end

      def enable(enable=true)
        if enable
          @txtdesc.enable
          @txtprice.enable
          @txtcant.enable
          @btnsave.enable
        else
          @txtdesc.disable
          @txtcant.disable
          @txtprice.disable
          @btnsave.disable
        end
      end

      def purchase=(purr)
        @purchase = purr
        update_widgets
      end

      def on(action, block)
        @actions[action] = block
      end
      
      protected

      def update_data
        return if @purchase.nil?

        @purchase.amount = @txtcant.text.to_i
        @purchase.unitary_cost = @txtprice.text.to_f
        @purchase.desc = @txtdesc.text
      end
      
      def on_btnsave_click(...)
        update_data
        @purchase.save
        reset_input

        @actions[:on_save]&.call
      end
      
      def assign_handlers
        @btnsave.connect SEL_COMMAND, method(:on_btnsave_click)        
      end

      def reset_input
        @lblproduct.text = 'Producto: '
        @txtdesc.text = ''
        @txtcant.text = '1'
        @txtprice.text = '1.0'
      end

      def update_widgets
        if @purchase.nil?
          reset_input
          enable false
        else
          @lblproduct.text = "Producto: #{@purchase.product.name}"
          @txtdesc.text = @purchase.desc
          @txtcant.text = @purchase.amount.to_s
          @txtprice.text = @purchase.unitary_cost.to_s
          enable true
        end
      end
    end    
  end
end
