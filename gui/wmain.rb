# coding: utf-8
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
require_relative 'appointments'
require_relative 'exporter'
require_relative 'inventory'
require_relative 'wabout'
require_relative 'wvetwindow'

# User interface module.
module GUI
  include Fox
  # Main MDI Window.
  #
  # Manage the MDI childs and modal used by the main window.
  class WMain < FXMainWindow
    def initialize(app)
      super app, 'Vet', opts: DECOR_ALL, x: 0, y: 0, width: 800, height: 600

      @children = {}
      @csv_products_exporter = Exporters::CSVProductExporter.new app, 'Exportar Productos a CSV',
                                                                 opts: DECOR_ALL,
                                                                 x: 20, y: 20,
                                                                 width: 450, height: 200
      @csv_sells_exporter = Exporters::CSVSellsExporter.new app, 'Exportar Ventas a CSV',
                                                            opts: DECOR_ALL,
                                                            x: 20, y: 20,
                                                            width: 550, height: 450
      @csv_purchases_exporter = Exporters::CSVPurchasesExporter.new app, 'Exportar Compras a CSV',
                                                                    opts: DECOR_ALL,
                                                                    x: 20, y: 20,
                                                                    width: 550, height: 450

      @fmenubar = FXMenuBar.new self, LAYOUT_SIDE_TOP | LAYOUT_FILL_X
      @fstatusbar = FXStatusBar.new self, LAYOUT_SIDE_BOTTOM | LAYOUT_FILL_X | STATUSBAR_WITH_DRAGCORNER
      @fmdiclient = FXMDIClient.new self, LAYOUT_FILL_X | LAYOUT_FILL_Y

      create_mdi_menu
      create_window_menu

      create_mdi_childs
      assign_handlers
    end

    def show_child(child)
      return unless @children.member? child

      @children[child].show
    end

    private

    def assign_handlers
      connect SEL_CLOSE do
        getApp.exit
      end
    end

    def create_window_menu
      # Program menu
      menu = FXMenuPane.new self
      cmd = FXMenuCommand.new menu, '&Salir'
      cmd.connect SEL_COMMAND, method(:on_exit_clicked)

      FXMenuTitle.new @fmenubar, '&Programa', nil, menu

      # Window menu
      menu = FXMenuPane.new self
      cmd = FXMenuCommand.new menu, '&Bienvenida'
      cmd.connect SEL_COMMAND, method(:on_bienvenida_clicked)
      cmd = FXMenuCommand.new menu, '&Información y Soporte'
      cmd.connect SEL_COMMAND, method(:on_about_clicked)
      cmd = FXMenuCommand.new menu, '&Turnos'
      cmd.connect SEL_COMMAND, method(:on_turnos_clicked)
      cmd = FXMenuCommand.new menu, '&Stock'
      cmd.connect SEL_COMMAND, method(:on_stock_clicked)
      cmd = FXMenuCommand.new menu, '&Compra'
      cmd.connect SEL_COMMAND, method(:on_purchase_clicked)
      cmd = FXMenuCommand.new menu, '&Venta'
      cmd.connect SEL_COMMAND, method(:on_sell_clicked)
      cmd = FXMenuCommand.new menu, '&Listar Ventas'
      cmd.connect SEL_COMMAND, method(:on_sellslist_clicked)
      cmd = FXMenuCommand.new menu, '&Listar Comprados'
      cmd.connect SEL_COMMAND, method(:on_purchaseslist_clicked)
      FXMenuSeparator.new menu
      FXMenuCommand.new menu, 'Tile &Horizontally', nil, @fmdiclient, FXMDIClient::ID_MDI_TILEHORIZONTAL
      FXMenuCommand.new menu, 'Tile &Vertically', nil, @fmdiclient, FXMDIClient::ID_MDI_TILEVERTICAL
      FXMenuCommand.new menu, 'C&ascada', nil, @fmdiclient, FXMDIClient::ID_MDI_CASCADE
      FXMenuCommand.new menu, '&Cerrar', nil, @fmdiclient, FXMDIClient::ID_MDI_CLOSE

      FXMenuTitle.new @fmenubar, '&Ventanas', nil, menu

      # Export menu
      menu = FXMenuPane.new self
      cmd = FXMenuCommand.new menu, '&Exportar Productos a CSV'
      cmd.connect SEL_COMMAND, method(:on_csv_products_clicked)
      cmd = FXMenuCommand.new menu, '&Exportar Ventas a CSV'
      cmd.connect SEL_COMMAND, method(:on_csv_sells_clicked)
      cmd = FXMenuCommand.new menu, '&Exportar Compras a CSV'
      cmd.connect SEL_COMMAND, method(:on_csv_purchases_clicked)

      FXMenuTitle.new @fmenubar, '&Exportar', nil, menu
    end

    def create_mdi_menu
      @fmdimenu = FXMDIMenu.new self, @fmdiclient
      FXMDIWindowButton.new @fmenubar, @fmdimenu, @fmdiclient, FXMDIClient::ID_MDI_MENUWINDOW, LAYOUT_LEFT

      FXMDIDeleteButton.new @fmenubar, @fmdiclient, FXMDIClient::ID_MDI_MENUCLOSE, FRAME_RAISED | LAYOUT_RIGHT
      FXMDIRestoreButton.new @fmenubar, @fmdiclient, FXMDIClient::ID_MDI_MENURESTORE, FRAME_RAISED | LAYOUT_RIGHT
      FXMDIMinimizeButton.new @fmenubar, @fmdiclient, FXMDIClient::ID_MDI_MENUMINIMIZE, FRAME_RAISED | LAYOUT_RIGHT
    end

    def create_mdi_childs
      @children[:welcome] = WVetWindow.new @fmdiclient, self, 225, 0, 350, 550
      @children[:appointments] = Appointments::WAppointmentList.new @fmdiclient
      @children[:stock] = Inventory::WStock.new @fmdiclient, 'Stock', nil, nil, 0, 10, 10, 700, 500
      @children[:purchase] = Inventory::WPurchase.new @fmdiclient, 'Compra', nil, nil, 0, 10, 10, 700, 500
      @children[:sell] = Inventory::WSell.new @fmdiclient, 'Venta', nil, nil, 0, 10, 10, 700, 500
      @children[:about] = WAbout.new @fmdiclient, 10, 0, 500, 500
      @children[:sellslist] = Inventory::WSellsList.new @fmdiclient, 'Lista de ventas', nil, nil,
                                                        0, 10, 10, 700, 500
      @children[:purchaseslist] = Inventory::WPurchasesList.new @fmdiclient, 'Lista de comprados', nil, nil, 0,
                                                                10, 10, 700, 500

      @children.each do |_name, child|
        child.hide
      end

      @children[:welcome].show
      @fmdiclient.setActiveChild @children[:welcome]
    end

    def on_bienvenida_clicked(_sender, _sel, _ptr)
      show_child :welcome
    end

    def on_about_clicked(_sender, _sel, _ptr)
      show_child :about
    end

    def on_turnos_clicked(_sender, _sel, _ptr)
      show_child :appointments
    end

    def on_stock_clicked(_sender, _sel, _ptr)
      show_child :stock
    end

    def on_purchase_clicked(_sender, _sel, _ptr)
      show_child :purchase
    end

    def on_purchaseslist_clicked(_sender, _sel, _ptr)
      show_child :purchaseslist
    end

    def on_sell_clicked(_sender, _sel, _ptr)
      show_child :sell
    end

    def on_sellslist_clicked(_sender, _sel, _ptr)
      show_child :sellslist
    end

    def on_csv_products_clicked(_sender, _sel, _ptr)
      @csv_products_exporter.show
    end

    def on_csv_sells_clicked(_sender, _sel, _ptr)
      @csv_sells_exporter.show
    end

    def on_csv_purchases_clicked(_sender, _sel, _ptr)
      @csv_purchases_exporter.show
    end

    def on_exit_clicked(_sender, _sel, _ptr)
      getApp.exit
    end
  end
end
