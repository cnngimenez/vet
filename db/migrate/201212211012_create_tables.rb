# Copyright 2020 Christian Gimenez
# 
# 201212211012_create_tables.rb
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

# CreateTables < 
class CreateTables < ActiveRecord::Migration[6.0]
  def up
    create_table :appointments do |t|
      t.datetime :time_start

      t.datetime :time_end
      t.string :title
      t.text :desc
    end                
  end

  def down
    drop_table :appointments
  end
end # CreateTables < 
