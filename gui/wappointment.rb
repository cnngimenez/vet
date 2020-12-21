# coding: utf-8
require 'fox16'
include Fox

require_relative 'wtimerange'
require_relative '../models'
include Models

module GUI
  # Appointment widget
  class WAppointment < FXVerticalFrame
    def initialize(...)
      super(...)

      @lst = Array.new
      
      @fxlist = FXList.new self, :opts => LAYOUT_FILL_X
      
      @fxtxt = FXTextField.new self, 50, :opts => LAYOUT_FILL_X
      @fxtxt.text = "Título"
      @fxtxt.helpText = "Título del turno"
      @fxtxt.tipText= "Título del turno"

      @wtime = WTimeRange.new self

      @fxdesc = FXText.new self, :opts => LAYOUT_FILL_X
      
      @fxbtn = FXButton.new self, "Nuevo Turno", :opts => LAYOUT_FILL_X
      @fxbtn.connect SEL_COMMAND do |sender, sel, data|
        ap = Appointment.create title: @fxtxt.text,
                                time_start: @wtime.time_start.to_i,
                                time_end: @wtime.time_end.to_i,
                                desc: @fxdesc.text
        ap.save
        add_appointment ap
        
        reset_input
      end

      update_widgets
    end

    def reset_input
      @fxtxt.text = ""
      @fxdesc.text = ""
      @wtime.reset
    end
    
    def add_appointment(appointment)
      @lst.push appointment
      update_widgets
    end

    private
    
    def update_widgets
      @fxlist.clearItems
      @lst.each do |ap|
        @fxlist.appendItem ap.to_s
      end      
    end
  end # WAppointment
end
