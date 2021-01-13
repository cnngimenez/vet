# Copyright 2020 Christian Gimenez
#
# wproductfilter.rb
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

# User Interface module
module GUI
  module Inventory
    include Models
    include Fox

    # Product Filter Widget
    #
    # Show a list of products with a filter at the top. The when the user write
    # a text on the filter only shows the products with that text on its name.
    class WProductFilter < FXVerticalFrame
      def initialize(...)
        super(...)

        @stock = Product.all.to_a
        @filtered = []
        @actions = { on_select: nil,
                     on_deselect: nil,
                     on_double_click: nil }

        @ftxtfilter = FXTextField.new self, 50, opts: TEXTFIELD_NORMAL | LAYOUT_FILL_X
        @flist = FXList.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL

        assign_handlers

        filter '' # This updates widgets while emptying the filter.
      end

      def filter(data)
        @filtered = @stock.select do |product|
          product.name.include? data
        end
        update_widgets
      end

      def on_select(sender, sel, data)
        @actions[:on_select]&.call sender, sel, data
      end

      def on_deselect(sender, sel, data)
        @actions[:on_deselect]&.call sender, sel, data
      end

      def on_double_click(_sender, _sel, data)
        product = @stock[data]
        @actions[:on_double_click]&.call product
      end

      def on(action, &block)
        @actions[action] = block
      end

      def update_stock
        @stock = Product.all.to_a
        filter ''
        update_widgets
      end

      def stock=(lst)
        @stock = lst
        filter ''
        update_widgets
      end

      attr_reader :stock

      # Add a product
      #
      # @param product [Models.Product]
      def add_product(product)
        return if @stock.member? product
        @stock.push product
        filter ''
      end

      def selected_product
        return nil if @flist.currentItem.nil?

        @filtered[@flist.currentItem]
      end

      def reset_input
        @flist.killSelection
      end

      def update_widgets
        @flist.clearItems
        @filtered.each do |product|
          @flist.appendItem product.to_s
        end

        @flist.selectItem 0, true if @filtered.count == 1
      end

      private

      def assign_handlers
        @ftxtfilter.connect SEL_CHANGED do |_sender, _sel, data|
          filter data
        end
        @flist.connect SEL_SELECTED do |sender, sel, data|
          on_select sender, sel, data
        end
        @flist.connect SEL_DESELECTED do |sender, sel, data|
          on_deselect sender, sel, data
        end
        @flist.connect SEL_DOUBLECLICKED do |sender, sel, data|
          on_double_click sender, sel, data
        end
      end
    end
  end
end
