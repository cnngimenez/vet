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

# frozen_string_literal: true

require 'fox16'

require_relative 'wtime'

module GUI
  # Common components for other GUI windows or widgets.
  module CommonWidgets
    include Fox

    # Time Range Widget
    #
    # Allow the user to select a starting and ending time (not date).
    class WTimeRange < FXHorizontalFrame
      def initialize(...)
        super(...)

        @interval = 30 * 60 # 30 minutes

        @wstart = WTime.new self
        @fxsep = FXLabel.new self, ' -- '
        @wend = WTime.new self

        reset
      end

      def reset
        @wstart.time = Time.now
        @wend.time = Time.now + @interval
      end

      def range
        [@wstart.time, @wend.time]
      end

      # @param arr [Array] An array with two Time instance.
      def range=(arr)
        @wstart.time = arr[0]
        @wend.time = arr[1]
      end

      def time_start
        @wstart.time
      end

      def time_end
        @wend.time
      end
    end
  end
end
