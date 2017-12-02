
require_relative  './module'
require_relative  './module_counter'
require_relative  './module_valid'
require_relative  './module_9'
require_relative  './module_valid91'

class Car
  include Manufacturer
  include InstanceCounter
  include Valid
  include Validation
  extend Module9

  #att_accessor_with_history :atr, :number, :color
  
  variable_zero

  def initialize
    register_instance
  end 

  def validate1!
    raise ArgumentError, 'Указанные объекты не являются железнодорожными вагонами' if self.class != Car
  end
end

class PassengerCar < Car
  #include Manufacturer
  #include InstanceCounter
  #include Valid
  #include Module9

  variable_zero

  def validate1!
    raise ArgumentError, 'Указанные объекты не являются пассажирскими вагонами' if self.class != PassengerCar
  end
end

class CargoCar < Car
  #include Manufacturer
  #include InstanceCounter
  #include Valid
  #include Module9

  variable_zero

  def validate1!
    raise ArgumentError, 'Указанные объекты не являются товарными вагонами' if self.class != CargoCar
  end
end
