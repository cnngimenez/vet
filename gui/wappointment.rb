# coding: utf-8
require 'fox16'
include Fox

require_relative 'wtime'

module GUI
  # Appointment widget
  class WAppointment < FXVerticalFrame
    def initialize(...)
      super(...)
      
      @fxlist = FXList.new self, :opts => LAYOUT_FILL_X
      
      @fxtxt = FXTextField.new self, 50, :opts => LAYOUT_FILL_X
      @fxtxt.text = "Título"
      @fxtxt.helpText = "Título del turno"
      @fxtxt.tipText= "Título del turno"

      @wstart = WTime.new self
      @wend = WTime.new self

      @fxfdesc = FXText.new self, :opts => LAYOUT_FILL_X
      
      @fxbtn = FXButton.new self, "Nuevo Turno", :opts => LAYOUT_FILL_X
      @fxbtn.connect SEL_COMMAND do |sender, sel, data|
        @fxlist.appendItem @fxtxt.text
        @fxtxt.text = ""
      end
    end
  end # WAppointment
end
