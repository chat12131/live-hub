class ArtistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artist, only: [:show, :edit, :update, :destroy, :toggle_favorite]

  def index
    artists_scope = current_user.artists.order(created_at: :desc)
    @artists = artists_scope.to_a
    @recent_artists = artists_scope.limit(3)
    @artist = current_user.artists.build
  end

  def show
    @display_attributes = {
      "アーティスト名" => @artist.name,
      "ニックネーム" => @artist.nickname,
      "ジャンル" => @artist.genre,
      "結成日" => @artist.founding_date,
      "初ライブ日" => @artist.first_show_date,
      "メモ" => @artist.memo
    }.select { |_, value| value.present? }
  end

  def new
    @artist = Artist.new
  end

  def list
    @artists = current_user.artists.order(created_at: :desc)
  end

  def edit
  end

  def create
    @artist = current_user.artists.build(artist_params)
    if @artist.save
      redirect_target = (params[:artist][:from].presence || artists_path)
      redirect_to "#{redirect_target}?selected_artist_id=#{@artist.id}", notice: "アーティストを作成しました。"
    else
      artists_scope = current_user.artists.order(created_at: :desc)
      @artists = artists_scope.to_a
      @recent_artists = artists_scope.limit(3)
      render 'index'
    end
  end

  def update
    if @artist.update(artist_params)
      redirect_target = (params[:artist][:from].presence || artists_path)
      redirect_to "#{redirect_target}?selected_artist_id=#{@artist.id}"
    else
      render 'edit'
    end
  end

  def destroy
    @artist.destroy
    redirect_to artists_path, notice: "アーティストを削除しました。"
  end

  def favorites
    @favorite_artists = current_user.artists.where(favorited: true)
  end

  def toggle_favorite
    @artist.update!(favorited: !@artist.favorited)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_artist
    @artist = current_user.artists.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :nickname, :image, :genre, :memo, :nickname_mode, :favorited, :founding_date, :first_show_date, { members_attributes: [:id, :name, :_destroy] })
  end
end
