require_relative 'wappointment_list'

module GUI
  class WVetWindow < FXMainWindow
    def initialize(app)
      super(app, "Vet", :opts => DECOR_ALL, :x => 100, :y => 100)
      @appointment = WAppointment_List.new self
    end

    def appointment
      return @appointment
    end
  end
end
