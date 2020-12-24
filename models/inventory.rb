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

require 'active_record'

module Models

  class Product < ActiveRecord::Base
    has_many :purchases
    has_many :sells
    
    validates :name, presence: true
    validates :stock, presence: true, numericality: {only_integer: true}

    def to_s
      "#{name} (#{code}) #{stock}"
    end
  end # Product

  class Purchase < ActiveRecord::Base    
    belongs_to :product

    validates :amount, presence: true, numericality: {only_integer: true}
    validates :product, presence: true
    validates :unitary_cost, presence: true, numericality: true
    validates :date, presence: true, numericality: true

    def total
      unitary_cost * amount
    end
    
    def short_name
      if product.nil?
        " " * 10
      else        
        if product.name.length > 10
          product.name[0..10]
        else
          product.name + " " * (10 - product.name.length)
        end
      end
    end

    def to_s
      "#{short_name} $#{unitary_cost} x #{amount} = #{total}"
    end
  end # Purchase

  class Sell < ActiveRecord::Base
    belongs_to :product

    validates :amount, presence: true, numericality: {only_integer: true}
    validates :product, presence: true
    validates :unitary_cost, presence: true, numericality: true
    validates :date, presence: true, numericality: true

    def total
      unitary_cost * amount
    end
    
    def short_name
      if product.nil?
        " " * 10
      else        
        if product.name.length > 10
          product.name[0..10]
        else
          product.name + " " * (10 - product.name.length)
        end
      end
    end
    
    def to_s
      "#{short_name} $#{unitary_cost} x #{amount} = #{total}"
    end
  end # Sell
  
end # Models
