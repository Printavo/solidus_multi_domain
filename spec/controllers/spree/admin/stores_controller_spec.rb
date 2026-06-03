require 'spec_helper'

describe Spree::Admin::StoresController do
  stub_authorization!

  describe '#index' do
    render_views

    it 'renders' do
      get :index
      # be_success was removed in Rails 5+; use be_successful.
      # (mirrors solidusio-contrib/solidus_multi_domain#98)
      expect(response).to be_successful
    end
  end

  describe '#edit' do
    render_views

    let(:store) { create(:store) }

    it 'renders' do
      get :edit, params: { id: store.to_param }
      expect(response).to be_successful
    end
  end
end
