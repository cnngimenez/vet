require 'fox16'

include Fox

module GUI
  # Appointment widget
  class WAppointment < FXGroupBox
    def initialize(parent)
      super(parent, "Appointments", :opts => LAYOUT_FILL_X)
      
      @fxlist = FXList.new self, :opts => LAYOUT_FILL_X
      @fxbtn = FXButton.new self, "Ver", :opts => LAYOUT_FILL_X
    end
  end # WAppointment
end
