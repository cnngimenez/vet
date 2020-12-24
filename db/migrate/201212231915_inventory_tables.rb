# Copyright 2020 Christian Gimenez
# 
# 201212231915_inventory_tables.rb
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

require 'active_record'

class InventoryTables < ActiveRecord::Migration[6.0]
  def up
    create_table :products do |t|
      t.string :name
      t.string :code
      t.integer :stock

      t.timestamps
    end

    create_table :purchases do |t|
      t.float :unitary_cost
      t.integer :amount
      t.date :expiration
      t.date :date
      t.text :desc
      t.integer :product_id
      
      t.timestamps
    end
    add_foreign_key :purchases, :products

    create_table :sells do |t|
      t.float :unitary_cost
      t.integer :amount
      t.date :date
      t.text :desc
      t.integer :product_id
      
      t.timestamps
    end
    add_foreign_key :sells, :products

    add_index :products, :name
    add_index :products, :id
    add_index :purchases, :id
    add_index :sells, :id
  end

  def down
    drop_table :products
    drop_table :purchases
    drop_table :sells
  end 
end # InventoryTables
                                                
