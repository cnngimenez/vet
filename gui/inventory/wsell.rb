# Copyright 2020 Christian Gimenez
# 
# wsell.rb
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

require_relative '../../models'
include Models

require_relative 'wbill'

module GUI
  class WSell < WBill
    def initialize(...)
      super(...)

      @btnaction.text = "Vender"
    end

    protected

    def create_obj(data)
      Sell.create data
    end
    
  end # WSell
end #GUI