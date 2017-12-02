#Написать модуль, содержащий 2 метода, которые можно вызывать на урвне класса:
#метод att_accessor_with_history. Динамически создает геттеры и сеттеры для любого кол-ва атрибутов,
#при этом сеттер сохраняет все значения инстанс-переменной при изменении этого значения.
#Также должен быть метод <имя_атрибута>_history, который возвращает массив всех значений данной переменной.
#метод strong_attr_acessor, который принимает имя атрибута и его класс.
# При этом создается геттер и сеттер для одноименной инстанс-переменной, 
#но сеттер проверяет тип присваемоего значения. Если тип отличается от того, 
#который указан вторым параметром, то выбрасывается исключение. 
#Если тип совпадает, то значение присваивается.
#Подключить модуль в класс и продемонстрировать применение этих методов.

module Module9
 
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history_name = {}
      history_name[name] = []
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) { |value| instance_variable_set(var_name, value);
     	                                  history_name[name] << value } 
      define_method("#{name}_history".to_sym) { history_name[name] } 
    end
  end
   
   def strong_attr_acessor (name, type)
     var_name = "@#{name}".to_sym
     var_type = type.to_s
     define_method(name) { instance_variable_get(var_name) }
     define_method("#{name}=".to_sym) { |value| raise ArgumentError,'Значение переменной не того класса' unless  value.is_a? var_type;
                                        instance_variable_set(var_name, value) }
   end                                     
end

class Test
  extend Module9

  strong_attr_acessor :name, :Integer

  attr_accessor_with_history :my_attr, :number, :color
end
