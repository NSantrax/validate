    #Написать модуль Validation, который:
     #   Содержит метод класса validate. Этот метод принимает в качестве параметров имя проверяемого атрибута, 
     #а также тип валидации и при необходимости дополнительные параметры.
      #  Возможные типы валидаций:
       #     presence - требует, чтобы значение атрибута было не nil и не пустой строкой. Пример использования: 
       #validate :name, :presence
        #    format (при этом отдельным параметром задается регулярное выражение для формата). Треубет соответствия значения атрибута 
        #заданному регулярному выражению. Пример: validate :number, :format, /A-Z{0,3}/
         #   type (третий параметр - класс атрибута). Требует соответствия значения атрибута заданному классу. Пример: validate :station, 
         #:type, RailwayStation
        #Содержит инстанс-метод validate!, который запускает все проверки (валидации), указанные в классе через метод класса validate. 
        #В случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла.
        #Содержит инстанс-метод valid? который возвращает true, если все проверки валидации прошли успешно и false, если есть ошибки 
        #валидации.
    #Заменить валидации в проекте железной дороги на этот модуль и методы из него.


module Validation9

  def self.included(base)
    base.extend ClassMetods
    base.send :include, InstanceMetods
  end

  module ClassMetods

  def validate(name, *args)
    args.flatten!
    if args[0] == :presense
      raise NamenilError,"Значение переменной #{name} отсутствует" if args.last == '' || args.last == nil

    elsif args[0] == :format       
      raise ArgumentError, "Формат переменной #{name} не задан" unless args[1].to_s =~ /.*/
      raise FormatError, "Значение переменной #{name} имеет неправильный формат" unless args.last.to_s =~ args[1]

    elsif args[0] == :type
      raise ArgumentError, 'Тип не задан' if args[1] == nil
      raise TypeinstanceError,"Значение переменной #{name} не того класса" unless args.last.class == args[1]

    else
      raise ValidError,'Такого типа валидации не существует'
    end
  end
end

  module InstanceMetods

    def valid?
      args = instance_variables
      args.each do |arg|
        var_name = arg.to_s.delete("@").to_sym
        instance = self.class.const_get(:INSTANCE)
        self.class.validate var_name, instance[var_name], self.instance_variable_get(arg)
      end
      true
      rescue ArgumentError => e
      p e.inspect
      false
    end
  end
end

class Test

  INSTANCE = { name: [:type, Fixnum], number: [:format, /^[0-9]{1,2}$/ ], color: [:presense] }.freeze

  include Validation9

  extend Module9

  strong_attr_acessor :name, Fixnum

  attr_accessor_with_history :number, :color

end

class ValidError < ArgumentError; end

class NamenilError < ArgumentError; end

class FormatError < ArgumentError; end

class TypeinstanceError < ArgumentError; end
