# Copyright 2020 Christian Gimenez
# 
# wtimerange.rb
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

require_relative 'wtime'

module GUI
  class WTimeRange < FXHorizontalFrame
    def initialize(...)
      super(...)

      @interval = 30 * 60  # 30 minutes

      @wstart = WTime.new self
      @fxsep = FXLabel.new self, " -- "
      @wend = WTime.new self

      reset      
    end

    def reset
      @wstart.time = Time.now
      @wend.time = Time.now + @interval
    end
    
    def range
      return [@wstart.time, @wend.time]
    end

    # @param arr [Array] An array with two Time instance.
    def range=(arr)
      @wstart.time = arr[0]
      @wend.time = arr[1]
    end

    def time_start
      return @wstart.time
    end

    def time_end
      return @wend.time
    end
    
  end # WTimeRange
end # GUI
