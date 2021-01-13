# Copyright 2020 Christian Gimenez
# 
# db.rb
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

module DB

  attr_reader :current_connection
  
  class DBConnection
    def initialize
      @connection = nil
      @schema = nil
    end

    def connect
      @connection = ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3', database: 'database.sqlite3')
    end

    def migrate
      if @connection.connection.migration_context.needs_migration?
        @connection.connection.migration_context.migrate
      end
    end
    
  end 
end
