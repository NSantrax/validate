# Маршрут:
# Имеет начальную и конечную станцию, а также список промежуточных станций
# Может добавлять станцию в список
# Может удалять станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной

class Route
  attr_reader :base_station, :end_station

  def initialize(base_station, end_station)
    @base_station = base_station
    @end_station = end_station
    @stations_list = [base_station, end_station]
    validate!
    p 'Начальная и конечные станции маршрута:'
    list
  end

  def list
    @list = []
    @stations_list.each { |station| @list << station.name }
    @list
  end

  attr_reader :stations_list

  def add_station(station)
    raise ArgumentError, 'Указанный объект не являются железнодорожной станцией' if station.class != RailwayStation
    @stations_list.insert(1, station)
    list
    validate!
    p 'Cтанция добавлена'
  end

  def delete_station(name)
    @stations_list.delete(name) { 'Такой станции в маршруте нет' }
    list
  end

  protected

  def validate!
    @stations_list.each { |station| raise ArgumentError, 'Указанные объекты не являются железнодорожными станциями' if station.class != RailwayStation }
  end
end
