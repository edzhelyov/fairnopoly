#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

include Warden::Test::Helpers

describe 'Article management' do
  include CategorySeedData

  context "for signed-in users" do
    before :each do
      @user = FactoryGirl.create :user
      login_as @user, scope: :user
    end

    describe "article creation" do

      context "with an invalid user" do
        before { @user.forename = nil }

        it "should redirect with an error" do
          visit new_article_path
          current_path.should eq edit_user_registration_path
          page.should have_content I18n.t 'article.notices.incomplete_profile'
        end
      end

      context "with a valid user", slow: true do
        before do
          FactoryGirl.create :category, parent: nil
          visit new_article_path
        end

        it "should have the correct title" do
          page.should have_content(I18n.t("article.titles.new"))
        end

        it 'creates an article' do
          lambda do
            fill_in I18n.t('formtastic.labels.article.title'), with: 'Article title'
            check Category.root.name
            within("#article_condition_input") do
              choose "article_condition_new"
            end

            if @user.is_a? LegalEntity
              fill_in I18n.t('formtastic.labels.article.basic_price'), with: '99,99'
              select I18n.t("enumerize.article.basic_price_amount.kilogram"), from: I18n.t('formtastic.labels.article.basic_price_amount')
              if @user.country == "Deutschland"
                select 7 ,from: I18n.t('formtastic.labels.article.vat')
              end
            end
            fill_in I18n.t('formtastic.labels.article.content'), with: 'Article content'
            check "article_transport_pickup"
            select I18n.t("enumerize.article.default_transport.pickup") , from: I18n.t('formtastic.labels.article.default_transport')
            fill_in 'article_transport_details', with: 'transport_details'
            check "article_payment_cash"
            select I18n.t("enumerize.article.default_payment.cash") , from: I18n.t('formtastic.labels.article.default_payment')
            fill_in 'article_payment_details', with: 'payment_details'

            find(".double_check-step-inputs").find(".action").find("input").click
          end.should change(Article.unscoped, :count).by 1
        end

        it "should create an article from a template" do
          base_article = FactoryGirl.create :article, :without_image
          template = FactoryGirl.create :article_template, article: base_article, user: @user
          visit new_article_path template_select: { article_template: template.id }
          page.should have_content I18n.t('template_select.notices.applied', name: template.name)
        end

        it 'shows sub-categories' do
          setup_categories

          visit new_article_path
          hardware_id = Category.find_by_name!('Hardware').id

          page.should have_selector("label[for$='article_categories_and_ancestors_#{hardware_id}']", visible: false)
          check "article_categories_and_ancestors_#{Category.find_by_name!('Elektronik').id}"
          check "article_categories_and_ancestors_#{Category.find_by_name!('Computer').id}"
          page.should have_selector("label[for$='article_categories_and_ancestors_#{hardware_id}']", visible: true)
        end
      end
    end

    describe "article search", search: true do
      before do
        article = FactoryGirl.create :article, title: 'chunky bacon'
        Sunspot.commit
        visit root_path
      end

      context "when submitting" do
        before { fill_in 'search_input', with: 'chunky bacon' }

        it "should show the page with search results" do
          click_button 'Suche'
          page.should have_link 'chunky bacon'
        end

        it "should rescue an Errno::ECONNREFUSED" do
          Article.stub(:search).and_raise(Errno::ECONNREFUSED)
          click_button 'Suche'
          page.should have_content I18n.t 'article.titles.sunspot_failure'
        end
      end
    end

    describe "article update", slow: true do
      before do
        @article = FactoryGirl.create :preview_article, seller: @user
        visit edit_article_path @article
      end

      it "should succeed and redirect" do
        fill_in 'article_title', with: 'foobar'
        click_button I18n.t 'article.labels.continue_to_preview'

        @article.reload.title.should eq 'foobar'
        current_path.should eq article_path @article
      end

      it "should fail given invalid data but still try to save images" do
        ArticlesController.any_instance.should_receive(:save_images).and_call_original
        Image.any_instance.should_receive :save
        old_title = @article.title

        fill_in 'article_title', with: ''
        click_button I18n.t 'article.labels.continue_to_preview'

        @article.reload.title.should eq old_title
      end
    end

    describe "article reporting" do
      before do
        @article = FactoryGirl.create :article
        visit article_path @article
      end

      it "should succeed" do
        fill_in 'report', with: 'foobar'
        click_button I18n.t 'article.actions.report'

        page.should have_content I18n.t 'article.actions.reported'
      end

      it "should fail with an empty report text" do
        fill_in 'report', with: ''
        click_button I18n.t 'article.actions.report'

        page.should have_content I18n.t 'article.actions.reported-error'
      end
    end
  end

  context "for signed-out users" do
    describe "the article index" do
      it "should be accessible" do
        visit articles_path
        page.status_code.should be 200
      end
    end

    describe "the article view" do
      before do
        @article = FactoryGirl.create :article
        visit article_path @article
      end

      it "should be accessible" do
        visit article_path @article
        page.status_code.should be 200
      end

      it "should rescue ECONNREFUSED errors" do
        Article.stub(:search).and_raise(Errno::ECONNREFUSED)
        visit article_path @article
        page.should have_content I18n.t 'article.show.no_alternative'
      end

      # it "should have a different title image with an additional param" do
      #   new_img = FactoryGirl.create :image
      #   @article.images << new_img
      #   @article.save

      #   Image.should_receive(:find).with(new_img.id.to_s)
      #   visit article_path @article, image: new_img
      # end
    end
  end
end
