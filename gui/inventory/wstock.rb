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

# User interface module
module GUI
  include Fox
  include Models

  # The Stock Window
  #
  # Display and manage the stocked products.
  class WStock < WProductList
    def initialize(...)
      super(...)

      @wproduct = WProduct.new @fright, 'Nuevo Producto', opts: FRAME_NORMAL | LAYOUT_FILL_X
      @btnnew = FXButton.new @fright, 'Nuevo producto', opts: LAYOUT_CENTER_X | BUTTON_NORMAL

      assign_handlers
      update_widgets
    end

    def add_product(product)
      return false unless product.valid?

      product.save
      @wpf.add_product product
      update_widgets
    end

    protected

    def reset_input
      @wproduct.reset
    end

    private

    def assign_handlers
      @wpf.on :on_double_click do |product|
        wpf_double_clicked product
      end
      @btnnew.connect SEL_COMMAND do |_sender, _sel, _data|
        p = @wproduct.product
        add_product p unless @wpf.stock.member? p
        reset_input
      end
    end

    def wpf_double_clicked(product)
      @wproduct.edit product
    end
  end
end
