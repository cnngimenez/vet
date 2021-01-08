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

# User interface module.
module GUI
  include Fox

  class WMain < FXMainWindow
    def initialize(app)
      super app, 'Vet', opts: DECOR_ALL,
            x: 100, y: 100, width: 700, height: 700

      @fmdiclient = FXMDIClient.new self, LAYOUT_FILL_X | LAYOUT_FILL_Y

      create_mdi_childs
    end

    private

    def create_mdi_childs
      @mwelcome = WVetWindow.new @fmdclient
      @mappointments = WAppointment_List.new @fmdiclient
      # @mstock = WStock.new @fmdiclient
      # @mpurchase = WPurchase.new @fmdiclient
      # @msell = WSell.new @fmdiclient
    end
  end
end
