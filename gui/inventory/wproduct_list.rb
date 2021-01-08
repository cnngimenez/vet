# Copyright 2020 Christian Gimenez
#
# wproduct_list.rb
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
require_relative 'wproduct'
require_relative 'wproduct_filter'

# User interface module
module GUI
  include Fox
  include Models

  # Widget to display a list of products.
  class WProductList < FXMDIChild
    def initialize(...)
      super(...)

      @fmain = FXVerticalFrame.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y

      @ftop = FXHorizontalFrame.new @fmain, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @wpf = WProductFilter.new @ftop, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @fright = FXVerticalFrame.new @ftop

      connect SEL_CLOSE do |_sender, _sel, _data|
        self.visible = FALSE
        1 # This avoids deleting itself when closing
      end
    end

    def update_stock
      @wpf.update_stock
    end

    def stock=(new_stock)
      @wpf.stock = new_stock
      update_widgets
    end

    def stock
      @wpf.stock
    end

    def selected_product
      @wpf.selected_product
    end

    def show
      super
      update_widgets
    end

    protected

    def reset_input
      @wpf.reset_input
    end

    def update_widgets
      @wpf.update_stock
      @wpf.update_widgets
    end
  end
end
