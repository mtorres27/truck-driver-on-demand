module Authentication
  extend ActiveSupport::Concern

  included do
    %w(admin company freelancer).each do |user_type|
      define_method "current_#{user_type}" do
        begin
          unless instance_variable_get("@current_#{user_type}")
            if session["#{user_type}_token"]
              instance_variable_set("@current_#{user_type}", user_type.classify.constantize.find_by(token: session["#{user_type}_token"]))
            end
          end
          instance_variable_get("@current_#{user_type}")
        rescue Exception => e
          nil
        end
      end

      define_method "authenticate_#{user_type}!" do
        unless send("current_#{user_type}")
          redirect_to new_session_path(section: user_type), alert: "You must be logged in to access the #{user_type} section."
        end
      end

      helper_method "current_#{user_type}"
    end
  end
end
