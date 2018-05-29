require 'rails_helper'

describe MainController, type: :controller  do
  describe 'GET job_countries' do
    it 'renders job_currencies' do
      get :job_countries, params: { country: 'gb' }
      expect(response).to render_template('main/_job_currencies')
    end
  end
end