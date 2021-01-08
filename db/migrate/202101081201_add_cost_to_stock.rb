# Copyright 2021 Christian Gimenez
#
# 202101081201_add_cost_to_stock.rb
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

require 'active_record'

# Insert the cost collumn into the stock table
class AddCostToStock < ActiveRecord::Migration[6.0]
  def up
    change_table :products do |t|
      t.float :unitary_cost
    end
  end

  def down
    change_table :products do |t|
      t.remove :unitary_cost
    end
  end
end
