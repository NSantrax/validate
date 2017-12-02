
# У класса RailwayStation написать метод, который принимает блок и выполняет действия из блока над каждым поездом (Train), находящимся в данный момент на станции.
require_relative './module_valid'
require_relative  './module_valid91'

class RailwayStation
  #include Valid
  include Validation

  NAME_FORMAT = /^[a-z0-9-]+$/i

  attr_reader :name
  
  @@stations = []

  @validations = []

  validate :name, :presence
  validate :name, :format, NAME_FORMAT

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = { PassengerTrain: [], CargoTrain: [] }
    @@stations << @name
    #validate!
  end

  def blocks
    raise ArgumentError, 'На станции нет поездов' if @trains[:PassengerTrain].empty? && @trains[:CargoTrain].empty?
    if block_given?
      @trains[:PassengerTrain].each { |train| yield(train) }
      @trains[:CargoTrain].each { |train| yield(train) }
    else p 'Блок не задан'
    end
  end

  def take_train(train)
    type = train.class.to_s
    if trains = @trains[type.to_sym]
      trains.push(train)
      train.braking(0)
      p "Поезд прибыл на станцию #{name}"
    else
      p 'Поезд  данного типа станция принять не может'
    end
  end

  def list
    p 'Пассажирские поезда №№:'
    @trains[:PassengerTrain].each { |train| p train.number }
    p 'Товарные поезда №№:'
    @trains[:CargoTrain].each { |train| p train.number }
  end

  def take_way(train)
    type = train.class.to_s
    if trains = @trains[type.to_sym]
      trains.delete(train) { 'Поезда нет на станции' }
      p "Поезд отбыл со станции #{name}"
    end
  end

  def del(train)
    type = train.class.to_s
    trains = @trains[type.to_sym]
    trains.delete(train)
  end

  protected

  #def validate!
  #  raise ArgumentError, 'Названию не присвоено значение' if @name == ''
  #  raise ArgumentError, 'Название имеет неправильный формат' if @name !~ NAME_FORMAT
  #end
end
