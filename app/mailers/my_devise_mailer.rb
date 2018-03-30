class MyDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  include Devise::Mailers::Helpers
  default from: 'AV Junction <info@avjunction.com>', template_path: 'mailers', template_name: 'default'

  def confirmation_instructions(record, token, opts={})
    @token = token
    @scope_name = Devise::Mapping.find_scope!(record)
    @resource = instance_variable_set("@#{devise_mapping.name}", record)
    headers 'X-SMTPAPI' => {
        sub: {
            '%email%' => [@email],
            '%confirmation_url%' => [confirmation_url(@resource, confirmation_token: @token)]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'ba24288b-64cb-48e8-bd71-53cdab11b22b'
                }
            }
        }
    }.to_json
    devise_mail(record, :confirmation_instructions, opts)
  end

  def reset_password_instructions(record, token, opts={})
    @token = token
    @scope_name = Devise::Mapping.find_scope!(record)
    @resource = instance_variable_set("@#{devise_mapping.name}", record)
    headers 'X-SMTPAPI' => {
        sub: {
            '%resource_email%' => [@resource.email],
            '%edit_password_url%' => [edit_password_url(@resource, reset_password_token: @token)]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'e5e88b04-84e4-498b-aae1-18f08b07c5fa'
                }
            }
        }
    }.to_json
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, token, opts={})
    @token = token
    @scope_name = Devise::Mapping.find_scope!(record)
    @resource = instance_variable_set("@#{devise_mapping.name}", record)
    headers 'X-SMTPAPI' => {
        sub: {
            '%resource_email%' => [@resource.email],
            '%unlock_url%' => [unlock_url(@resource, unlock_token: @token)]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'e2070c12-0e4a-4194-a311-cf0b79d17116'
                }
            }
        }
    }.to_json
    devise_mail(record, :unlock_instructions, opts)
  end

  def email_changed(record, opts={})
    @scope_name = Devise::Mapping.find_scope!(record)
    @resource = instance_variable_set("@#{devise_mapping.name}", record)
    if @resource.try(:unconfirmed_email?)
      @new_email = @resource.unconfirmed_email
    else
      @new_email = @resource.email
    end
    headers 'X-SMTPAPI' => {
        sub: {
            '%email%' => [@email],
            '%new_email%' => [@new_email],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '2c95801f-4e6f-478f-86ec-e8a4322c251f'
                }
            }
        }
    }.to_json
    devise_mail(record, :email_changed, opts)
  end

  def password_change(record, opts={})
    @scope_name = Devise::Mapping.find_scope!(record)
    @resource = instance_variable_set("@#{devise_mapping.name}", record)
    headers 'X-SMTPAPI' => {
        sub: {
            '%resource_email%' => [@resource.email],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '3c544d54-4f7a-4d2c-ab06-29dadf021203'
                }
            }
        }
    }.to_json
    devise_mail(record, :password_change, opts)
  end
end