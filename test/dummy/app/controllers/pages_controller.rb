class PagesController < ApplicationController
  respond_to :html, :json
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  def index
    @pages = Page.all
    respond_with @pages
  end

  # GET /pages/1
  def show
    respond_with @page
  end

  # GET /pages/new
  def new
    @page = Page.new
    respond_with @page
  end

  # GET /pages/1/edit
  def edit
    respond_with @page
  end

  # POST /pages
  def create
    @page = Page.new(page_params)
    flash[:notice] = 'Page was successfully created.' if @page.save
    respond_with @page
  end

  # PATCH/PUT /pages/1
  def update
    flash[:notice] = 'Page was successfully updated.' if @page.update(page_params)
    respond_with @page
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:active, :name, :description, translations_attributes: [:id, :title, :locale, :_destroy])
    end
end
