# Copyright 2021 Christian Gimenez
#
# inventory.rb
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

require_relative 'inventory/wstock'
require_relative 'inventory/wpurchase'
require_relative 'inventory/wsell'
require_relative 'inventory/wsellslist'
require_relative 'inventory/wpurchaseslist'

module GUI
  # GUI to manage Stock, Sell and Purchase instances.
  #
  # Widgets and MDIWindows to manage everything related with the stock and inventory.
  module Inventory
  end
end
