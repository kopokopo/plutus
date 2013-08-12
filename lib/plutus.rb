# Plutus
require "rails"
module Plutus
  class Engine < Rails::Engine
    #isolate_namespace Plutus
    #isolate_namespace Plutus if defined? isolate_namespace  #dondeng rails 3.0 modification
    #ActionController::Base.send :include, Plutus
    engine_name :plutus
  end
end
