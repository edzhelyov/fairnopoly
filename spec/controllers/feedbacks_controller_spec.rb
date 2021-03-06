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

describe FeedbacksController do

  render_views

  describe "POST 'create'" do

    before :each do
      @user = FactoryGirl.create(:user)
      @article = FactoryGirl.create(:article)
    end

    describe "for non-signed-in users" do
      it "should not create an feedback with variety report_article" do
        expect {
          post :create, :user_id => @user, :article_id => @article, :variety => :report_article, :text => "test"
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe "for signed-in users" do

      before :each do
        sign_in @user
      end

     # it "should create an feedback with variety report_article" do
     #   lambda do
     #     post :create, :user_id => @user.id, :article_id => @article.id, :variety => "send_feedback", :text => "test"
     #   end.should change(Feedback , :count).by 1
     # end

    end
  end
end





