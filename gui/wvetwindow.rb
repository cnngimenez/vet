require_relative 'wappointment'

module GUI
  class WVetWindow < FXMainWindow
    def initialize(app)
      super(app, "Vet", :opts => DECOR_ALL, :x => 100, :y => 100)

      @cal = FXCalendar.new self
      @appointment = WAppointment.new self
    end

    def appointment
      return @appointment
    end
  end
end
