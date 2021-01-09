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

# User interface module.
module GUI
  include Fox
  # Tips widget
  #
  # A widget to show tips for the user.
  class WTips < FXMDIChild
    def initialize(mdiclient, tip_name)
      super mdiclient, 'Tips', nil, nil, 0, 10, 10, 350, 450
      @tip_name = tip_name

      f1 = FXVerticalFrame.new self, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y
      @txt = FXText.new f1, nil, 0, TEXT_READONLY | TEXT_WORDWRAP | LAYOUT_FILL_X | LAYOUT_FILL_Y

      create_styles
      load_tips
    end

    protected

    def create_styles
      # Bold
      bold = FXHiliteStyle.from_text(@txt)
      bold.style = FXText::STYLE_BOLD
      # H1
      h1 = FXHiliteStyle.from_text(@txt)
      h1.normalBackColor = FXColor::LightBlue
      h1.style = FXText::STYLE_UNDERLINE

      @txt.styled = true
      @txt.hiliteStyles = [h1, bold]
    end

    H1REGEXP = /^#[ ]+(.*)$/
    BOLDREGEXP = /\*\*(.*)\*\*/

    def apply_styles
      str = @txt.text
      matches = str.to_enum(:scan, H1REGEXP).map { Regexp.last_match }
      matches.each do |match|
        pos = @txt.findText match[0]
        @txt.changeStyle(pos.first[0], match[0].length, 1)
      end
      matches = str.to_enum(:scan, BOLDREGEXP).map { Regexp.last_match }
      matches.each do |match|
        pos = @txt.findText match[0]
        @txt.changeStyle pos.first[0], match[0].length, 2
      end
    end

    def tip_filepath
      "gui/tips/#{@tip_name}.md"
    end

    def load_tips
      return unless File.exist? tip_filepath

      @txt.text = File.read tip_filepath
      apply_styles
    end
  end
end
