# Copyright 2020 Christian Gimenez
#
# wtime.rb
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

module GUI
  # Common components for other GUI windows or widgets.
  module CommonWidgets
    include Fox
    class WTime < FXHorizontalFrame
      def initialize(...)
        super(...)

        @time = Time.now

        txtopts = TEXTFIELD_INTEGER | TEXTFIELD_LIMITED | TEXTFIELD_NORMAL
        @fxhour = FXTextField.new self, 2, opts: txtopts

        @fxhour.connect SEL_VERIFY do |_sender, _sel, data|
          @fxhour.text = if data.to_i > 24
                           '1'
                         elsif data.to_i <= 0
                           '1'
                         else
                           data
                         end
        end
        @fxhour.connect SEL_CHANGED do |_sender, _sel, _data|
          update_time
        end

        @fxsep = FXLabel.new self, ' : '

        @fxmin = FXTextField.new self, 2, opts: txtopts
        @fxmin.connect SEL_VERIFY do |_sender, _sel, data|
          @fxmin.text = if data.to_i >= 60
                          '0'
                        elsif data.to_i < 0
                          '0'
                        else
                          data
                        end
        end
        @fxmin.connect SEL_CHANGED do |_sender, _sel, _data|
          update_time
        end

        update_widgets
      end

      def time=(time)
        @time = time
        update_widgets
      end

      def time
        update_time
        @time
      end

      private

      def update_widgets
        @fxhour.text = @time.hour.to_s
        @fxmin.text = @time.min.to_s
      end

      def update_time
        n = Time.now
        @time = Time.new n.year, n.month, n.day, @fxhour.text.to_i, @fxmin.text.to_i, nil, nil
      end
    end
  end
end
