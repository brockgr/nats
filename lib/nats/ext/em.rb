begin
  require 'eventmachine'
rescue LoadError
  require 'rubygems'
  require 'eventmachine'
end
