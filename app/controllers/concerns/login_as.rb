module LoginAs
  extend ActiveSupport::Concern

  def login_as
    section = params[:section]
    obj = section.classify.constantize.find(params[:id])

    session["#{section}_id".to_sym] = obj.id
    session["#{section}_token".to_sym] = obj.token

    redirect_to send("#{section}_root_path")
  end
end
