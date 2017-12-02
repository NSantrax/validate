# Создать модуль, который позволит указывать название компании-производителя и получать его. Подключить модуль к классам Вагон и Поезд
module Manufacturer
  attr_accessor :manufacturer

  def assign_manufacturer(manufacturer)
    @manufacturer = manufacturer
  end

  def manufacturer
    @manufacturer
  end
end
