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
require "spec_helper"

describe ArticlesHelper do

  describe "#get_category_tree(leaf_category)" do
    it "should return an array with parent categories of a given child category " do
      parent_category = FactoryGirl.create :category
      child_category = FactoryGirl.create :category, parent: parent_category

      helper.get_category_tree(child_category).should eq [parent_category, child_category]
    end
  end



  describe "options_format_for (type, method, css_classname)" do
     before do
      helper.stub(:resource).and_return FactoryGirl.create :article, :transport_uninsured => true, :transport_uninsured_price => 3, :transport_uninsured_provider => "test"
     end

    it "should return 'kostenfrei'" do
      helper.options_format_for("transport","pickup","").should match /(kostenfrei)/
    end

    it "should return 'zzgl.'" do
      helper.options_format_for("transport","uninsured","").should match /zzgl. /
    end

  end

  describe "#fair_alternative_to", search: true do
     before do
       @normal_article =  FactoryGirl.create :article ,:category1, :title => "weisse schockolade"
       @other_normal_article = FactoryGirl.create :article,:category2 , :title => "schwarze schockolade aber anders"
       @not_related_article = FactoryGirl.create :article,:category1 , :title => "schuhcreme"
       @fair_article = FactoryGirl.create :article, :simple_fair ,:category1 , :title => "schwarze fairtrade schockolade"

       Sunspot.commit
     end

     it "should find a fair alternative in with the similar title and category" do
        (helper.find_fair_alternative_to @normal_article).should eq @fair_article
     end

      it "should find a fair alternative in with the similar title and other category" do
        (helper.find_fair_alternative_to @other_normal_article).should eq @fair_article
     end

     it "should prefer the same category over matches in the title" do
        @other_fair_article = FactoryGirl.create :article, :simple_fair ,:category2 , :title => "weisse schockolade"
         Sunspot.commit
        (helper.find_fair_alternative_to @other_normal_article).should eq @other_fair_article
     end

     it "should not find an unrelated article" do
        (helper.find_fair_alternative_to @not_related_article).should eq nil
     end

  end

  describe "#rate_article" do

     it "should return 3 on fair article" do
        @article = FactoryGirl.create :article, :simple_fair
        (helper.rate_article  @article).should eq 3
     end

     it "should return 2 on eco article" do
         @article = FactoryGirl.create :article, :simple_ecologic
         (helper.rate_article  @article).should eq 2
     end

      it "should return 1 on old article" do
         @article =  FactoryGirl.create :second_hand_article
        (helper.rate_article  @article).should eq 1
     end

     it "should return 0 on normal article" do
        @article =  FactoryGirl.create :no_second_hand_article
        (helper.rate_article  @article).should eq 0
     end

     it "should return 0 on nil article" do
        @article =  nil
        (helper.rate_article  @article).should eq 0
     end

  end



  # describe "#category_shift(level)" do
  #   it "should return the correct css" do
  #     helper.category_shift(1).should eq 'padding-left:10px;'
  #   end
  # end
end
