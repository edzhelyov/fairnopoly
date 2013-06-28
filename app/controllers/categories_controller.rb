class CategoriesController < InheritedResources::Base

  actions :show

  before_filter :authorize_resource
  skip_before_filter :authenticate_user!

  def authorize_resource
    authorize resource
  end

  def show
    show! do |format|
      format.json { render :json => resource.to_json(:include => :children) }
    end
  end

  respond_to :json,:js

end
