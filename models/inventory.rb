# Copyright 2020 Christian Gimenez
#
# inventory.rb
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

require 'active_record'

# Models module.
module Models
  # Product model
  #
  # Registers a product name, stock and its selling cost.
  class Product < ActiveRecord::Base
    has_many :purchases
    has_many :sells

    validates :name, presence: true
    validates :stock, presence: true, numericality: { only_integer: true }
    validates :unitary_cost, presence: true, numericality: true

    # @return [float]
    def last_purchased_price
      purr = purchases.order(:date).last
      if purr.nil?
        0.0
      else
        purr.unitary_cost
      end
    end

    def to_s
      "#{name} (#{code}) $#{unitary_cost} #{stock}u"
    end

    # @return [Array] An array of strings.
    def to_csv_array
      [code, name, unitary_cost, stock]
    end

    class << self
      def csv_header
        %w[code name unitary_cost stock]
      end
    end
  end

  # Purchase model.
  #
  # Each purchase to a mayor producer/provider is registered with its cost and
  # the product purchased.
  class Purchase < ActiveRecord::Base
    belongs_to :product

    validates :amount, presence: true, numericality: { only_integer: true }
    validates :product, presence: true
    validates :unitary_cost, presence: true, numericality: true
    validates :date, presence: true, numericality: true

    # Total cost of this purchase
    #
    # @return [Float]
    def total
      unitary_cost * amount
    end

    # Set the #date attribute with a Time instance.
    #
    # @param time_obj [Time]
    def t_date=(time_obj)
      self.date = time_obj.to_i
    end

    # Return the #date attribute with a Time instance.
    #
    # @return [Time]
    def t_date
      Time.at date
    end

    def short_name
      return ' ' * 10 if product.nil?

      name = product.name
      if name.length > 10
        name[0..10]
      else
        name + ' ' * (10 - name.length)
      end
    end

    def to_s
      s_date = t_date.to_formatted_s :short
      "#{short_name} $#{unitary_cost} x #{amount} = #{total}  #{s_date}"
    end
  end

  # Sell model.
  #
  # Each sell to a client is registered with date, cost, the product and the
  # amount sold.
  class Sell < ActiveRecord::Base
    belongs_to :product

    validates :amount, presence: true, numericality: { only_integer: true }
    validates :product, presence: true
    validates :unitary_cost, presence: true, numericality: true
    validates :date, presence: true, numericality: true

    def total
      unitary_cost * amount
    end

    # Set the #date attribute with a Time instance.
    #
    # @param time_obj [Time]
    def t_date=(time_obj)
      self.date = time_obj.to_i
    end

    # Return the #date attribute with a Time instance.
    #
    # @return [Time]
    def t_date
      Time.at date
    end

    def short_name
      return ' ' * 10 if product.nil?

      name = product.name
      if name.length > 10
        name[0..10]
      else
        name + ' ' * (10 - name.length)
      end
    end

    def to_s
      s_date = t_date.to_formatted_s :short
      "#{short_name} $#{unitary_cost} x #{amount} = #{total}  #{s_date}"
    end

    def to_csv_array
      [product.name, unitary_cost, amount, date]
    end

    class << self
      # What is the CSV Header used by #to_csv_array ?
      #
      # @return [Array] An array of String instances.
      def csv_header
        %w[product_name unitary_cost amount date]
      end

      # Return all sells between a date range.
      #
      # @param range [Hash] A hash with :from and :to keys defined. Values are Time objects.
      #   Ex.: `{ from: from_Time, to: to_Time }`
      def between_dates(range)
        from = range[:from].to_i
        to = range[:to].to_i
        Sell.where(date: from..to).all
      end
    end
  end
end
