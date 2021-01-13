# coding: utf-8
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

# User interface module
module GUI
  include Fox
  # A Welcome Window
  class WVetWindow < FXMDIChild

    TIPTEXT = <<~MESSAGE
    Siempre se recomienda realizar copias de respaldo de su base de datos para evitar pérdida de información. Para saber cómo, haga clic en el botón de Tips:
    MESSAGE
    
    def initialize(mdiclient, wmain, x = 0, y = 0, width = 500, height = 500)
      super mdiclient, 'Vet', nil, nil, 0, x, y, width, height
      @wmain = wmain

      @f1 = FXVerticalFrame.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @f2 = FXHorizontalFrame.new @f1, opts: LAYOUT_FILL_X

      @img = FXPNGImage.new app, File.binread(random_image_path)
      @imageview = FXImageFrame.new @f2, @img, width: 100, opts: 0
      @lblwelcome = FXLabel.new @f2, '  Vet  ', opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | LABEL_NORMAL
      # @lblwelcome.justify = JUSTIFY_CENTER_X
      font = FXFont.new getApp, 'courier', 25, FONTWEIGHT_BOLD
      @lblwelcome.font = font
     
      @btnappointments = FXButton.new @f1, 'Turnos', opts: LAYOUT_FILL_X | BUTTON_NORMAL
      @btnstock = FXButton.new @f1, 'Stock de productos', opts: LAYOUT_FILL_X | BUTTON_NORMAL
      @btnpurchase = FXButton.new @f1, 'Compra de productos', opts: LAYOUT_FILL_X | BUTTON_NORMAL
      @btnsell = FXButton.new @f1, 'Venta de productos', opts: LAYOUT_FILL_X | BUTTON_NORMAL
      @btnabout = FXButton.new @f1, 'Información y Soporte', opts: LAYOUT_FILL_X | BUTTON_NORMAL
      txt = FXText.new @f1, nil, 0, TEXT_READONLY | TEXT_WORDWRAP | LAYOUT_FILL_X | LAYOUT_FILL_Y
      txt.text = TIPTEXT
      WTipButton.new @f1, mdiclient, 'wabout'
      
      assign_handlers
    end

    private

    def assign_handlers
      @btnappointments.connect SEL_COMMAND do |_sender, _sel, _data|
        @wmain.show_child :appointments
      end
      @btnstock.connect SEL_COMMAND do |_sender, _sel, _data|
        @wmain.show_child :stock
      end
      @btnpurchase.connect SEL_COMMAND do |_sender, _sel, _data|
        @wmain.show_child :purchase
      end
      @btnsell.connect SEL_COMMAND do |_sender, _sel, _data|
        @wmain.show_child :sell
      end
      @btnabout.connect SEL_COMMAND do
        @wmain.show_child :about
      end
      connect SEL_CLOSE do
        hide
        1
      end
    end

    # Return a random image path.
    #
    # @return [String]
    def random_image_path
      types = %w[dog cat]
      number = rand 1..2
      type = types[rand 0..1]

      File.expand_path "../imgs/#{type}#{number}.png", __FILE__
    end
  end
end
