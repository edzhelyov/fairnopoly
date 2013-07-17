class MassUploadsController < ApplicationController

  def new
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new(user = current_user)
  end

  def show
    authorize Article.new, :create? # Needed because of pundit
    secret_mass_uploads_number = params[:id]
    @articles = Article.find_all_by_id(session[secret_mass_uploads_number])
  end


  def create
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new(current_user, params[:mass_upload])

    # Needed to show the right error messages if no file is selected since in
    # this case .new doesn't lead to the validate_input method.
    @mass_upload.validate_input(params[:mass_upload])
    if @mass_upload.errors.full_messages.any?
      render :new
    else
      secret_mass_uploads_number = SecureRandom.urlsafe_base64
      session[secret_mass_uploads_number] = []
      articles = @mass_upload
      articles.save
      articles.raw_articles.each do |article|
        session[secret_mass_uploads_number] << article.id
      end
      if articles.errors.full_messages.any?
        articles.missing_bank_details_errors(current_user)
        render :new
      else
        redirect_to mass_upload_path(secret_mass_uploads_number)
      end
    end
  end

  # bugbug vorlaeufige updatemthode
  def update
    authorize Article.new, :create? # Needed because of pundit
    secret_mass_uploads_number = params[:id]
    articles = Article.find_all_by_id(session[secret_mass_uploads_number])
    articles.each do |article|
      # bugbug Is this ok or should one try to use something like the change_state! method?
      article.activate
      article.save
      # bugbug Does this even make sense if it link to an anchor and the notice at the top isn't visible?
      flash[:notice] = I18n.t('article.notices.mass_upload_create')
    end
    redirect_to user_path(current_user) + "#offers"
  end
end
