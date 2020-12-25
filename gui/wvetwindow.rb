# Copyright 2020 Christian Gimenez
# 
# wvetwindow.rb
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

require_relative 'wappointment_list'
require_relative 'inventory/wstock'
require_relative 'inventory/wpurchase'
require_relative '../models'
include Models

module GUI
  class WVetWindow < FXMainWindow
    def initialize(app)
      super(app, "Vet", :opts => DECOR_ALL, :x => 100, :y => 100)
      
      @wstock = WStock.new app, "Stock"
      @wstock.stock = Product.all.to_a
      @wpurchase = WPurchase.new app, "Compra de productos"
      
      @f1 = FXHorizontalFrame.new self, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y
      @f2 = FXVerticalFrame.new @f1, :opts => LAYOUT_FILL_X      
      
      @img = FXPNGImage.new app, File.binread(get_random_image)
      @imageview = FXImageFrame.new @f2, @img, :width => 100, :opts => 0
     
      @btnstock = FXButton.new @f2, "Stock de productos", :opts => LAYOUT_FILL_X | BUTTON_NORMAL
      @btnstock.connect SEL_COMMAND do |sender, sel, data|
        @wstock.show
      end
      @btnstock = FXButton.new @f2, "Compra de productos", :opts => LAYOUT_FILL_X | BUTTON_NORMAL
      @btnstock.connect SEL_COMMAND do |sender, sel, data|
        @wpurchase.show
      end
      
      @appointment = WAppointment_List.new @f1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y

      self.connect SEL_CLOSE do |sender, sel, data|
        app.exit
      end
    end

    def get_random_image
      types = ["dog", "cat"]
      number = rand 1..2
      type = types[rand 0..1]
      
      File.expand_path "../imgs/#{type}#{number}.png", __FILE__
    end
    
    def appointment
      return @appointment
    end
  end
end
