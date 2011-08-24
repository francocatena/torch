class HintsController < ApplicationController
  before_filter :require_user, except: [:index, :show]
  before_filter :load_app
  
  # GET /apps/1/hints
  # GET /apps/1/hints.json
  def index
    @title = t('view.hints.index_title')
    @hints = @app.hints.paginate(page: params[:page], per_page: ROWS_PER_PAGE)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hints }
    end
  end

  # GET /apps/1/hints/1
  # GET /apps/1/hints/1.json
  def show
    @title = t('view.hints.show_title')
    @hint = @app.hints.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hint }
    end
  end

  # GET /apps/1/hints/new
  # GET /apps/1/hints/new.json
  def new
    @title = t('view.hints.new_title')
    @hint = @app.hints.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hint }
    end
  end

  # GET /apps/1/hints/1/edit
  def edit
    @title = t('view.hints.edit_title')
    @hint = @app.hints.find(params[:id])
  end

  # POST /apps/1/hints
  # POST /apps/1/hints.json
  def create
    @title = t('view.hints.new_title')
    @hint = @app.hints.build(params[:hint])

    respond_to do |format|
      if @hint.save
        format.html { redirect_to app_hint_url(@app, @hint), notice: t('view.hints.correctly_created') }
        format.json { render json: @hint, status: :created, location: @hint }
      else
        format.html { render action: 'new' }
        format.json { render json: @hint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1/hints/1
  # PUT /apps/1/hints/1.json
  def update
    @title = t('view.hints.edit_title')
    @hint = @app.hints.find(params[:id])

    respond_to do |format|
      if @hint.update_attributes(params[:hint])
        format.html { redirect_to app_hint_url(@app, @hint), notice: t('view.hints.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hint.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.hints.stale_object_error')
    redirect_to edit_app_hint_url(@app, @hint)
  end

  # DELETE /apps/1/hints/1
  # DELETE /apps/1/hints/1.json
  def destroy
    @hint = @app.hints.find(params[:id])
    @hint.destroy

    respond_to do |format|
      format.html { redirect_to app_hints_url(@app) }
      format.json { head :ok }
    end
  end
  
  private

  def load_app
    @app = App.find(params[:app_id]) if params[:app_id]
  end
end