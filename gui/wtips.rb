# Copyright 2021 Christian Gimenez
#
# wtips.rb
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
  include Fox
  class WTips < FXGroupBox
    def initialize(parent)
      super parent, 'Tips', opts: FRAME_NORMAL | LAYOUT_FILL_X

      icon = load_icon('tips_and_tricks')
      @btnshow = FXButton.new self, '', icon
    end

    private

    def load_icon(name)
      filename = File.expand_path("../imgs/#{name}.png", __FILE__)
      File.open(filename, "rb") do |f|
        FXPNGIcon.new(getApp(), f.read)
      end
    end
  end
end
