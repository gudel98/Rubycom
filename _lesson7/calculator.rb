class Calculator
  def sum(params)
    params.inject(0) { |mem, var| mem += var.to_i }
  end

  def mult(params=nil)
    return unless params
    value = if params.count < 3
              params.first.to_i * params.last.to_i
            else
              params.inject(1) { |mem, var| mem *= var.to_i }
            end
    { value: value, params: params }
  end

  def self.foo
    'STUBBED CLASS METHOD!'
  end
end
