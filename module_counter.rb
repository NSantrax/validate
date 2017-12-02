# Усложенное задание: Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы, которые подключаются автоматически
# при вызове include в классе:
# Методы класса:
# instances, который возвращает кол-во экземпляров данного класса
# Инастанс-методы:
# register_instance, который увеличивает счетчик кол-ва экземпляров класса и который можно вызвать из конструктора. При этом, данный метод не должен быть публичным.
module InstanceCounter
  def self.included(base)
    base.extend ClassMetods
    base.send :include, InstanceMetods
  end

  module ClassMetods
    def variable_zero
      @instances = 0
    end

    def variable
      @instances += 1
    end

    def instances
      @instances
    end
  end

  module InstanceMetods
    protected

    def register_instance
      self.class.variable
    end
  end
end
