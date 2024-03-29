class ImagesController < ApplicationController
  before_filter :require_user
  helper_method :sort_column, :sort_direction
  
  # GET /images
  # GET /images.json
  def index
    @title = t('view.images.index_title')
    images = Image.order(
      "#{sort_column} #{sort_direction.upcase}"
    )
    
    if params[:q].present?
      query = params[:q].strip.gsub(/\s+/, '%')
      images = images.where(
        ['LOWER(name) LIKE :q', 'LOWER(caption) LIKE :q'].join(' OR '),
        { q: "%#{query}%".downcase }
      )
    end
    
    @images = images.paginate(
      page: params[:page], per_page: ROWS_PER_PAGE
    )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @title = t('view.images.show_title')
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @title = t('view.images.new_title')
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
    @title = t('view.images.edit_title')
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    @title = t('view.images.new_title')
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: t('view.images.correctly_created') }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @title = t('view.images.edit_title')
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: t('view.images.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.images.stale_object_error')
    redirect_to edit_image_url(@app, @hint)
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :ok }
    end
  end
  
  private
  
  def sort_column
    %w[name caption].include?(params[:sort]) ? params[:sort] : 'name'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end