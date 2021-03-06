# Copyright 2020 Christian Gimenez
# 
# vet.rb
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
require 'fox16/calendar'
require_relative 'gui'
require_relative 'db'
require_relative 'models'

include Fox
include GUI

db = DB::DBConnection.new
db.connect
db.migrate

@app = FXApp.new 'Vet', 'Vet'

# @vw = WVetWindow.new @app
@vw = WMain.new @app
@vw.show

@app.create
@app.run
puts "Ended"
