# -*- coding: utf-8 -*-
def setup_authlogic_helper(options = nil)
  options = {
    :user_fixture => 'users',
    :user_session_class => 'UserSession',
    :current_user_session_name => '@current_user_session',
    :spec_user_session_name => '@user_session'
  }.update(options || {})
  
  self.module_eval(<<-"EOS", __FILE__, __LINE__)
    def login_as(user)
      mock_user_session = mock_model(#{options[:user_session_class]}, :user => user, :record => user)
      controller.instance_variable_set(:#{options[:current_user_session_name]}, mock_user_session)
      #{options[:spec_user_session_name]} = mock_user_session
    end

    def logout
      controller.instance_variable_set(:#{options[:current_user_session_name]}, nil)
    end
  EOS

  self.instance_eval(<<-"EOS", __FILE__, __LINE__)
    def login_as(user_fixture_name, &block)
      describe("when #{options[:user_fixture_name]} logged in") do
        before(:each) do
          user = #{options[:user_fixture]}(user_fixture_name)
          login_as(user)
        end
        block.bind(self).call
      end
    end

    def logout(&block)
      describe("when nobody logged in") do
        before(:each) do
          logout
        end
        block.bind(self).call
      end
    end
  EOS
end
