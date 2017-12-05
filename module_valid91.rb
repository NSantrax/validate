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


module Validation

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    attr_reader :validations

    def validate ( name, type_validation, param = nil )
       @validations ||= []
       @validations  << [name, type_validation, param]
       p @validations
    end
  end

  module InstanceMethods

    def validate!
      p self.class.validations
      self.class.validations.each do |validation|
        name = validation[0]
        type_validation = validation[1]
        param = validation[2]
        var = instance_variable_get("@#{name}")
      
        send("#{type_validation}_validation".to_sym, var, name, param)
      end
    end

      def presence_validation (var, name, param)
        raise ValidateError,"Значение переменной #{name} nil" if var.nil?
        raise ValidateError,"Значение переменной #{name} отсутствует" if var.to_s.empty?
      end
 
      def format_validation (var, name, param)      
        raise ValidateError, "Формат переменной #{name} не задан" if param.to_s.empty?
        raise ValidateError, "Значение переменной #{name} имеет неправильный формат" unless var.to_s =~ param
      end

      def type_validation (var, name, param)
        raise ValidateError, 'Тип не задан' if name.to_s.empty?
        raise ValidateError,"Значение переменной #{name} не того класса" unless var.is_a? param
      end

    def valid?
      validate!
      true
      rescue ValidateError => e
      p e.inspect       
      false
    end
  end
end

#class Test
  
 # include Validation

  #extend Module9

  #@validations = []

  #strong_attr_acessor :name, :Fixnum

  #attr_accessor_with_history :number, :color, :a

  
 # validate :name, :type, Fixnum
  #validate :color, :presence
 # validate :number, :format,  /^[0-9]{1,2}$/
#end

class ValidateError < ArgumentError; end
