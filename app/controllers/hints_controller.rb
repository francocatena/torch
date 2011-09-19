class HintsController < ApplicationController
  before_filter :require_user, except: [:index, :show]
  before_filter :load_app, :load_tag
  
  # GET /apps/1/hints
  # GET /apps/1/hints.json
  def index
    @title = t('view.hints.index_title')
    hints = @tag ? @tag.hints : @app.hints
    hints = hints.public unless current_user
    
    @hints = hints.order('importance ASC').paginate(
      page: params[:page], per_page: ROWS_PER_PAGE
    )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hints }
    end
  end

  # GET /apps/1/hints/1
  # GET /apps/1/hints/1.json
  def show
    @title = t('view.hints.show_title')
    @hint = (current_user ? @app.hints : @app.hints.public).find(params[:id])

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
  
  # GET /app/1/hints/1/history
  # GET /app/1/hints/1/history.json
  def history
    @title = t('view.hints.history_title')
    @hint = @app.hints.find(params[:id])
    @versions = @hint.versions.paginate(
      page: params[:page], per_page: ROWS_PER_PAGE
    )

    respond_to do |format|
      format.html # history.html.erb
      format.json { render json: @versions }
    end
  end
  
  # GET /app/1/hints/1/diff/2
  # GET /app/1/hints/1/diff/2.json
  def diff
    @title = t('view.hints.history_title')
    @hint = @app.hints.find(params[:id])
    @old_hint = @hint.versions.find(params[:version_id]).reify(has_one: false)

    respond_to do |format|
      format.html # diff.html.erb
      format.json { render json: [@hint, @old_hint] }
    end
  end
  
  private

  def load_app
    @app = App.find(params[:app_id]) if params[:app_id]
    @tags = @app.tags.with_hints.order('name ASC')
  end
  
  def load_tag
    @tag = @app.tags.find(params[:tag_id]) if params[:tag_id]
  end
end