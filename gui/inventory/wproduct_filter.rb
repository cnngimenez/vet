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

require 'fox16'
include Fox

require_relative '../../models'
include Models

module GUI
  class WProductFilter < FXVerticalFrame
    def initialize(...)
      super(...)

      @stock = Product.all.to_a
      @filtered = Array.new
      
      @actions = {
        on_select: nil,
        on_deselect: nil
      }
      
      @ftxtfilter = FXTextField.new self, 50, :opts => TEXTFIELD_NORMAL | LAYOUT_FILL_X
      @flist = FXList.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y | LIST_NORMAL

      @ftxtfilter.connect SEL_CHANGED do |sender, sel, data|
        filter data
      end
      @flist.connect SEL_SELECTED do |sender, sel, data|
        on_select sender, sel, data
      end
      @flist.connect SEL_DESELECTED do |sender, sel, data|
        on_deselect sender, sel, data
      end

      filter "" # This updates widgets while emptying the filter.
    end
    
    def filter(data)
      @filtered = @stock.select do |product|
        product.name.include? data
      end
      update_widgets
    end

    def on_select(sender, sel, data)
      unless @actions[:on_select].nil?
        @actions[:on_select].call sender, sel, data
      end
    end

    def on_deselect(sender, sel, data)
      unless @actions[:on_deselect].nil?
        @actions[:on_deselect].call sender, sel, data
      end
    end

    def on(action, &block)
      @actions[action] = block
    end

    def update_stock
      @stock = Product.all.to_a
      update_widgets
    end

    def stock=(lst)
      @stock = lst
      update_widgets
    end
        
    def stock
      return stock
    end
    
    def selected_product
      return nil if @flist.currentItem.nil?

      @stock[@flist.currentItem]
    end

    def reset_input
      @flist.killSelection
    end
    
    def update_widgets
      @flist.clearItems
      @filtered.each do |product|
        @flist.appendItem product.to_s
      end
    end
    
  end # WProductFiletr
end # GUI
