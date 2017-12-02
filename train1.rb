 # У класса Train написать метод, который принимает блок и проходит по всем вагонам поезда, передавая каждый объект вагона в блок.
require_relative './module'
#require_relative './module_valid'
require_relative './module_valid91'

class Train
  include Manufacturer
  include InstanceCounter
  #include Valid
  include Validation


  variable_zero
  @@trains = []
  @validations = []

  attr_writer :number, :number_cars
  attr_reader :station, :route, :number

  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i
  NUMBER_CARS_FORMAT = /^[0-9]{1,2}$/

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number_cars, :presence
  validate :number_cars, :format, NUMBER_CARS_FORMAT

  def self.find(num)
    @@trains.detect { |train| train.number == num }
  end

  def initialize(number, number_cars)
    @number = number
    @number_cars = number_cars
    #validate!
    @cars = []
    @speed = 0
    @route = nil
    @station = nil
    @station_number = nil
    @@trains << self
    register_instance
    i = 0
    while i < @number_cars.to_i
      attach_car
      i += 1
    end
  end

  def block_trains
    if block_given?
      @cars.each_with_index { |car, id| yield(car, id) }
    else
      p 'Блок не задан'
    end
  end

  #def valid?
  #  validate!
  #rescue
  #  false
  #end

  def speed?
    p "Сейчас скорость поезда  #{@speed} км/ч"
  end

  def number_cars?
    p "В поезде #{@number_cars} вагонов"
  end

  def acceleration(speed)
    @speed = speed if speed > @speed
  end

  def braking(speed)
    @speed = speed if speed < @speed && speed >= 0
  end

  def car
    @car = Car.new
  end

  def attach_car
    if @speed.zero?
      @cars << car
    else
      p 'Невозможно прицепить вагон, так как поезд движется'
    end
  end

  def unhook_car
    if @speed.zero?
      if @cars.any?
        @cars.pop
        p 'Вагон отцеплен'
      else
        p 'В поезде отcутствуют вагоны, отцепить невозможно.'
      end
    else
      p 'Невозможно отцепить вагон, так как поезд движется'
    end
  end

  def make_route(route)
    @station.take_way(self) unless @station.nil?
    @route = route.stations_list
    @station_number = 0
    @station = @route[0]
    @station.take_train(self)
  end

  def go_to_station(station)
    @station = station
    @route = nil
  end

  def move_train(direction)
    menu if @route.nil?
    size = @route.size - 1
    if direction == 0 && @station_number > 0
      @station_number -= 1
    elsif direction == 1 && @station_number < size
      @station_number += 1
    else
      raise ArgumentError, 'Движение поезда в этом направлении невозможно'
    end
    station_next = @route[@station_number]
    @station.take_way(self)
    station_next.take_train(self)
    @station = station_next
  rescue ArgumentError => e
    p e.inspect
  end

  def current_station
    if @route
      p "Текущая станция #{@station.name}"
      if  station_last = @route[@station_number -= 1]
        p "Предыдущая станция #{station_last.name}"
      else
        p 'Это станция отправления'
        if  station_next = @route[@station_number += 1]
          p "Следующая станция #{station_next.name}"
        else
          p 'Это конечная станция'
        end
      end
    else
      p 'Этому поезду не задан маршрут'
    end
  end

  def speed_zero?
    @speed.zero?
  end

  protected

  #def validate!
  # raise ArgumentError, 'Номеру не присвоено значение' if @number == ''
  # raise ArgumentError, 'Номер имеет неправильный  формат' if @number !~ NUMBER_FORMAT
  # raise ArgumentError, 'Не задано количество вагонов' if @number_cars == ''
  # raise ArgumentError, 'Количество вагонов должно быть цифрой от 0 до 99' if @number_cars !~ NUMBER_CARS_FORMAT
  #end
end

class PassengerTrain < Train
  #include Manufacturer
  #include InstanceCounter
  include Validation

  validations = []
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number_cars, :presence
  validate :number_cars, :format, NUMBER_CARS_FORMAT

  variable_zero

  def car
    @car = PassengerCar.new
  end
end

class CargoTrain < Train
  #include Manufacturer
  #include InstanceCounter
  include Validation
  validations = []
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number_cars, :presence
  validate :number_cars, :format, NUMBER_CARS_FORMAT

  variable_zero

  def car
    @car = CargoCar.new
  end
end
