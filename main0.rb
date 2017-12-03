
# 6Реализовать проверку (валидацию) данных для всех классов. Проверять основные атрибуты (название, номер, тип и т.п.) на наличие, длину и т.п. (в зависимости от атрибута):
# Валидация должна взываться при создании объекта, если объект невалидный, то должно выбрасываться исключение
# Должен быть метод valid? который возвращает true, если объект валидный и false - в противном случае.
# Релизовать проверку на формат номера поезда. Допустимый формат: три буквы или цифры в любом порядке, необязательный дефис (может быть, а может нет) и еще 2 буквы или цифры после дефиса.
# Релизовать интерфейс, который бы выводил пользователю ошибки валидации без прекращения работы программы.
# Убрать из классов все puts (кроме методов, которые и должны что-то выводить на экран), методы просто возвращают значения. (Начинаем бороться за чистоту кода).
# UPDATE к заданию:
#- Дополнительно сделать следующее: при добавлениит вагонов к поезду и несовпадении типов также выбрасывать исключение.
#- Для класса маршрута сделать валидацию на то, что при добавлении станций объекты имеют тип (класс) RailwayStation (или как он у вас называется).
#- Добавить валидацию (с выбросом исключения) на глобальную уникальность номера поезда. То есть, нельзя создать 2 объекта класса Train с одинаковым номером.

require_relative './railway_station0'
require_relative './route0'
require_relative './train1'
require_relative './car0'
require_relative  './module'
require_relative  './module_counter'
require_relative  './module_valid'
require_relative  './module_9'
require_relative  './module91'



class Main
  MENU_ACTIONS = { 0 => [:menu, 'меню'], 1 => [:train_new, 'создать новый поезд'],
                   2 => [:station_new, 'создать новую станцию'], 3 => [:route_new, 'создать новый маршрут'],
                   4 => [:train_all, 'показать список поездов'], 5 => [:station_all, 'показать список станций'],
                   6 => [:station_list, 'показать список поездов на станции'], 7 => [:station_take_train, 'отправить поезд на станцию'],
                   8 => [:move_train, 'переместить поезд'], 9 => [:train_attach_car, 'прицепить вагон к поезду'],
                   10 => [:train_unhook_car, 'отцепить вагон от поезда'], 11 => [:make_route, 'задать маршрут поезду'],
                   12 => [:add_station_route, 'добавить станцию к маршруту'], 13 => [:exit, 'выход'],
                   14 => [:block_station, 'блок для станции'], 15 => [:block_train, 'блок для поезда'] }.freeze

  def initialize
    @stations = []
    @routes  =  []
    @trains  =  {}
  end

  def run
    menu
  end

  def select_station
    p 'Выберите станцию'
    @stations.each_with_index { |station, id| p "#{id} - #{station.name}" }
    @index =  gets.chomp
    if @index == '0'
      @index = 0
    else
      @index = @index.to_i
      raise ArgumentError, 'Такой станции не существует' if @stations[@index].nil? || @index == 0
    end
  rescue ArgumentError => e
    p e.inspect
    menu
  end

  def select_train
    p 'Выберите номер поезда'
    @trains.each { |key, train| p "#{train.class} № #{key}" }
    number = gets.chomp
    if @trains.key?(number)
      @train = @trains[number]
    else p 'Такого поезда не существует'
         menu
    end
  end

  def select_route
    p 'Выберите номер маршрута'
    @routes.each_with_index { |route, id| p "#{id} - #{route.list}" }
    @index =  gets.chomp
    if @index == '0'
      @index = 0
    else
      @index = @index.to_i
      raise ArgumentError, 'Такого маршрута не существует' if @routes[@index].nil? || @index == 0
    end
    @route = @routes[@index]
  rescue ArgumentError => e
    p e.inspect
    menu
  end

  def menu
    MENU_ACTIONS.each { |key, command| puts "#{key} - #{command[1]}" }
    choice = gets.chomp.to_i
    if MENU_ACTIONS.key?(choice)
      send(MENU_ACTIONS[choice][0])
    else p 'Такой команды не существует'
         menu
    end
  end

  def train_new
    p 'Придумайте номер поезда'
    number = gets.chomp
    raise ArgumentError, 'Поезд с таким номером уже существует, придумайте другой' if @trains.key?(number)
    loop do
      puts 'Выберите тип поезда: 1 - пассажирский, 2 - товарный'
      @type = gets.chomp.to_i
      break if @type == 1 || @type == 2
      p 'Такого типа поезда не существует'
    end
    puts 'Выберите количесиво вагонов'
    number_cars = gets.chomp
    @trains[number] = PassengerTrain.new(number, number_cars) if @type == 1
    @trains[number] = CargoTrain.new(number, number_cars) if @type == 2
    p "Поезд #{number} успешно создан"
    menu
  rescue ArgumentError => e
    p e.inspect
    menu
  end

  def station_new
    p 'Придумайте название станции'
    name = gets.chomp
    while @stations.include?(name)
      puts 'Станция с таким названием уже существует, придумайте другое'
      name = gets.chomp
    end
    @stations << RailwayStation.new(name)
    p "Станция #{name} успешно создана"
    menu
  rescue ArgumentError => e
    p e.inspect
    menu
  end

  def route_new
    p 'Выберите начальную станцию'
    @stations.each_with_index { |station, id| p "#{id} - #{station.name}" }
    index = gets.chomp.to_i
    base_station = @stations[index]
    p 'Выберите конечную станцию'
    index = gets.chomp.to_i
    end_station = @stations[index]
    @routes <<  Route.new(base_station, end_station)
    p 'Выберите промежуточные станции разделяя их entr, по окончании введите entr'
    loop do
      n = gets.chomp
      raise ArgumentError, 'Маршрут успешно создан' if n == ''
      @station = @stations[n.to_i]
      @routes.last.add_station(@station)
    end
  rescue ArgumentError => e
    p e.inspect
    menu
  end

  def train_all
    p 'Список поездов:'
    @trains.each { |number, train| p "#{train.class} № #{number}" }
    menu
  end

  def station_all
    p 'Список станций:'
    @stations.each { |station| p station.name }
    menu
  end

  def station_list
    select_station
    @stations[@index].list
    menu
  end

  def station_take_train
    select_station
    select_train
    @train.station.del(@train) if @train.station
    @stations[@index].take_train(@train)
    @train.go_to_station(@stations[@index])
    menu
  end

  def move_train
    select_train
    if @train.route
      p 'Выберите направление движения: 1 - вперед, 0 - назад'
      direction = gets.chomp.to_i
      @train.move_train(direction)
    else
      p 'Этому поезду не задан маршрут'
    end
    menu
  end

  def train_attach_car
    select_train
    @train.attach_car
    p 'Вагон прицеплен'
    menu
  rescue ArgumentError => e
    p e.inspect
    menu
  end

  def train_unhook_car
    select_train
    @train.unhook_car
    menu
  end

  def make_route
    select_train
    select_route
    @train.make_route(@route)
    p 'Поезду задан выбранный маршрут'
    menu
  end

  def block_station
    select_station
    @station = @stations[@index]
    block = ->(x) { x.attach_car }
    @station.blocks(&block)
    p 'Вагоны прицеплены'
    menu
  end

  def block_train
    select_train
    block = proc { |car, id| p "#{id += 1} - #{car.class}" }
    @train.block_trains(&block)
    menu
  end

  def add_station_route
    select_route
    select_station
    @station = @stations[@index]
    @station
    @route.add_station(@station)
    menu
  rescue ArgumentError => e
    p e.inspect
    menu
  end
end

menu = Main.new
menu.run
