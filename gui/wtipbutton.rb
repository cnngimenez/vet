# Copyright 2021 Christian Gimenez
#
# wtipbutton.rb
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
require_relative 'wtips'

module GUI
  include Fox
  class WTipButton < FXButton
    ICONS = %w[cool FYI side_note take_note tips_and_tricks]

    def initialize(parent, mdiclient, tip_name, icon = nil)
      super parent, ''
      self.icon = if icon.nil?
                    load_random_icon
                  else
                    load_icon icon
                  end

      @mdiclient = mdiclient
      @tip_name = tip_name

      connect SEL_COMMAND, method(:on_clicked)
    end

    def load_random_icon
      load_icon ICONS[rand 0..(ICONS.count - 1)]
    end

    def load_icon(name)
      filename = File.expand_path("../imgs/#{name}.png", __FILE__)
      File.open(filename, 'rb') do |f|
        FXPNGIcon.new(getApp, f.read)
      end
    end

    protected

    def on_clicked(...)
      w = WTips.new @mdiclient, @tip_name
      w.create
      @mdiclient.setActiveChild w
    end
  end
end
