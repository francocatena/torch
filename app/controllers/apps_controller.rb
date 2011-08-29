class AppsController < ApplicationController
  before_filter :require_user, except: [:index, :show]
  
  # GET /apps
  # GET /apps.json
  def index
    @title = t('view.apps.index_title')
    @apps = App.paginate(page: params[:page], per_page: ROWS_PER_PAGE)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
    @title = t('view.apps.show_title')
    @app = App.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @title = t('view.apps.new_title')
    @app = App.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @title = t('view.apps.edit_title')
    @app = App.find(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    @title = t('view.apps.new_title')
    @app = App.new(params[:app])

    respond_to do |format|
      if @app.save
        format.html { redirect_to @app, notice: t('view.apps.correctly_created') }
        format.json { render json: @app, status: :created, location: @app }
      else
        format.html { render action: 'new' }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @title = t('view.apps.edit_title')
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to @app, notice: t('view.apps.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.apps.stale_object_error')
    redirect_to edit_app_url(@app)
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :ok }
    end
  end
  
  # GET /apps/1/tags.json
  def tags
    tags = App.find(params[:id]).tags.where(
      'LOWER(name) LIKE ?', "#{params[:q]}%"
    ).order('name ASC').limit(10)
    
    respond_to do |format|
      format.json { render json: tags }
    end
  end
end