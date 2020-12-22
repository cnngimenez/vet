# Copyright 2020 Christian Gimenez
# 
# wvetwindow.rb
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

require_relative 'wappointment_list'

module GUI
  class WVetWindow < FXMainWindow
    def initialize(app)
      super(app, "Vet", :opts => DECOR_ALL, :x => 100, :y => 100)

      @fxv1 = FXHorizontalFrame.new self, :opts => LAYOUT_FILL_X

      @img = FXPNGImage.new app, File.binread(get_random_image)
      @imageview = FXImageFrame.new @fxv1, @img, :width => 100
      
      @appointment = WAppointment_List.new @fxv1, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y      
    end

    def get_random_image
      types = ["dog", "cat"]
      number = rand 1..2
      type = types[rand 0..1]
      
      File.expand_path "../imgs/#{type}#{number}.png", __FILE__
    end
    
    def appointment
      return @appointment
    end
  end
end
