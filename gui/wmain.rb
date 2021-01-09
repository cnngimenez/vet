# Copyright 2021 Christian Gimenez
#
# wmain.rb
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
require_relative 'wappointment_list'
require_relative 'inventory/wstock'
require_relative 'inventory/wpurchase'
require_relative 'inventory/wsell'
require_relative 'wabout'

# User interface module.
module GUI
  include Fox

  class WMain < FXMainWindow
    def initialize(app)
      super app, 'Vet', opts: DECOR_ALL, x: 0, y: 0, width: 800, height: 600

      @fmenubar = FXMenuBar.new self, LAYOUT_SIDE_TOP | LAYOUT_FILL_X
      @fstatusbar = FXStatusBar.new self, LAYOUT_SIDE_BOTTOM | LAYOUT_FILL_X | STATUSBAR_WITH_DRAGCORNER
      @fmdiclient = FXMDIClient.new self, LAYOUT_FILL_X | LAYOUT_FILL_Y

      create_mdi_menu
      create_window_menu
     
      create_mdi_childs
    end

    private
    
    def create_window_menu
      menu = FXMenuPane.new self
      cmd = FXMenuCommand.new menu, '&Bienvenida'
      cmd.connect SEL_COMMAND, method(:on_bienvenida_clicked)
      cmd = FXMenuCommand.new menu, '&Turnos'
      cmd.connect SEL_COMMAND, method(:on_turnos_clicked)
      cmd = FXMenuCommand.new menu, '&Stock'
      cmd.connect SEL_COMMAND, method(:on_stock_clicked)
      cmd = FXMenuCommand.new menu, '&Compra'
      cmd.connect SEL_COMMAND, method(:on_compra_clicked)
      cmd = FXMenuCommand.new menu, '&Venta'
      cmd.connect SEL_COMMAND, method(:on_venta_clicked)

      FXMenuTitle.new @fmenubar, '&Ventanas', nil, menu
    end

    def create_mdi_menu
      @fmdimenu = FXMDIMenu.new self, @fmdiclient
      FXMDIWindowButton.new @fmenubar, @fmdimenu, @fmdiclient, FXMDIClient::ID_MDI_MENUWINDOW, LAYOUT_LEFT
      
      FXMDIDeleteButton.new @fmenubar, @fmdiclient, FXMDIClient::ID_MDI_MENUCLOSE, FRAME_RAISED | LAYOUT_RIGHT
      FXMDIRestoreButton.new @fmenubar, @fmdiclient, FXMDIClient::ID_MDI_MENURESTORE, FRAME_RAISED | LAYOUT_RIGHT
      FXMDIMinimizeButton.new @fmenubar, @fmdiclient, FXMDIClient::ID_MDI_MENUMINIMIZE, FRAME_RAISED | LAYOUT_RIGHT
    end
    
    def create_mdi_childs
      @mwelcome = WVetWindow.new @fmdiclient, 225, 0, 350, 350
      @mappointments = WAppointment_List.new @fmdiclient
      @mstock = WStock.new @fmdiclient, 'Stock', nil, nil, 0, 10, 10, 700, 500
      @mpurchase = WPurchase.new @fmdiclient, 'Compra', nil, nil, 0, 10, 10, 700, 500
      @msell = WSell.new @fmdiclient, 'Venta', nil, nil, 0, 10, 10, 700, 500
      @mabout = WAbout.new @fmdiclient, 10, 0, 500, 500
      
      @mstock.hide
      @msell.hide
      @mpurchase.hide
      @fmdiclient.setActiveChild @mwelcome
    end

    def on_bienvenida_clicked(_sender, _sel, _ptr)
      @mwelcome.show
    end
    def on_turnos_clicked(_sender, _sel, _ptr)
      @mappointments.show
    end
    def on_stock_clicked(_sender, _sel, _ptr)
      @mstock.show
    end
    def on_compra_clicked(_sender, _sel, _ptr)
      @mpurchase.show
    end
    def on_venta_clicked(_sender, _sel, _ptr)
      @msell.show
    end
    
  end
end
