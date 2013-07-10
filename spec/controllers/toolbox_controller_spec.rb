require 'spec_helper'

describe ToolboxController do
  #render_views

  describe "GET 'session'" do
    context "as json" do
      it "should be successful" do
        get :session, format: :json
        response.should be_success
      end
    end

    context "as html" do
      it "should fail" do
        get :session
        response.should_not be_success
      end
    end
  end

   describe "GET 'confirm'" do
    context "as js" do
      it "should be successful" do
        get :confirm, format: :js
        response.should be_success
      end
    end

    context "as html" do
      it "should fail" do
        get :confirm
        response.should_not be_success
      end
    end
  end

end
