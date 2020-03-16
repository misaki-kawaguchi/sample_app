class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #どのコントーラーでも使える
  include SessionsHelper
end
