class MembersController < ApplicationController
  def index
    @members = Member.where(artist_id: params[:artist_id])
    render json: @members
  end

  def destroy
    @member = Member.find(params[:id])
    @artist = @member.artist
    @member.destroy
    respond_to do |format|
      format.html { redirect_to artist_path(@artist) }
      format.js { render 'artists/destroy' }
    end
  end
end
