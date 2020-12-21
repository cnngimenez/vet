# Copyright 2020 Christian Gimenez
# 
# appointment.rb
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


require 'active_record'

module Models

  # Appointment class
  class Appointment < ActiveRecord::Base
    def to_s
      if time_start?
        tstart = Time.at time_start
      else
        tstart = "0"
      end
      if time_end?
        tend = Time.at time_end
      else
        tend = "0"
      end
      return tstart.strftime("%R") + " - " + tend.strftime("%R") + ": " + title
    end
  end # Appointment

  
  # AppointmentManager
  class AppointmentManager
    def initialize()
      @lst = Array.new
    end

    def add(appointment)
      @lst.push appointment
    end
    
  end # AppointmentManager
end
