class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /bookmarks or /bookmarks.json
  def index
    @bookmarks = Bookmark.all
  end

  # POST /bookmarks or /bookmarks.json
  def create
    @bookmark = Bookmark.new()
    @bookmark.user_id = current_user.id
    @bookmark.property_id = params[:property_id]

    if @bookmark.save
      flash[:notice] = 'You bookmarked ' + @bookmark.property.name
      redirect_back(fallback_location: root_path)
    end
  end

  # DELETE /bookmarks/1 or /bookmarks/1.json
  def destroy
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: "Bookmark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:property_id)
    end
end
