# Copyright 2021 Christian Gimenez
#
# IncomePlot.rb
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

require_relative '../models'
require 'gnuplot'

module Plotting
  # Generate an income plot.
  class IncomeOutcomePlot
    def initialize(from_date, to_date)
      @from_date = from_date
      @to_date = to_date
    end

    def dataset
      Models::Sell.get_dataset @from_date, @to_date
    end

    def new_plot(gnuplot = $stdout)
      Gnuplot::Plot.new(gnuplot) do |plot|
        plot.terminal 'png'
        plot.output File.expand_path '../tmp/income_plot.png', __dir__

        plot.title 'Ingresos'
        plot.xlabel 'Fecha'
        plot.ylabel '$'
        plot.timefmt '"%Y-%m-%d"'
        plot.xdata 'time'
        plot.format 'x "%d/%m/%y"'
        plot.xrange "[\"#{@from_date.strftime('%Y-%m-%d')}\" : \"#{@to_date.strftime('%Y-%m-%d')}\"]"

        plot.data << Gnuplot::DataSet.new(dataset) do |ds|
          ds.with = 'linespoints'
          ds.title = 'Ventas'
          ds.using = '1:2'
        end
      end
    end

    def generate_plot
      Gnuplot.open do |gp|
        new_plot gp
      end
    end
  end

  class IncomePlot < IncomeOutcomePlot
    def dataset
      Models::Sell.get_dataset @from_date, @to_date
    end
  end

  class OutcomePlot < IncomeOutcomePlot
    def dataset
      Models::Purchase.get_dataset @from_date, @to_date
    end
  end
end
