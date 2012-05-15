# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  private # protectedじゃないよ

  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == 'admin' && password == 'password'
    end
  end

end
