require 'spec_helper'

module Spree
  describe ProductsHelper do
    before(:each) do
      @store     = FactoryBot.create(:store)
      @taxonomy  = FactoryBot.create(:taxonomy, :store => @store)
      # NOTE: no upstream equivalent — upstream's spec (solidusio-contrib/solidus_multi_domain
      # 63f79e3) leaves the second taxonomy storeless. The Printavo fork's :taxonomy factory
      # requires a store (taxonomy belongs_to :store, required by default since Rails 5), so
      # give the second taxonomy its own store to keep it in a different store than @store.
      @taxonomy2 = FactoryBot.create(:taxonomy, :store => FactoryBot.create(:store))

      allow(helper).to receive(:current_store) { @store }
    end

    describe "#get_taxonomies" do
      it "only show taxonomies on current_store" do
        taxonomies = helper.get_taxonomies

        expect(taxonomies).to include(@taxonomy)
        expect(taxonomies).to_not include(@taxonomy2)
      end
    end
  end
end
