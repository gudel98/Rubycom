class MyRackMiddleware
  def initialize(appl)
    @appl = appl
  end

  def call(env)
    puts "Time start: #{Time.now}"
    status, headers, body = @appl.call(env)
    puts "Time stop: #{Time.now}"
    [status, headers, body]
  end
end
