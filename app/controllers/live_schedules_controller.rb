class LiveSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_live_schedule, only: [:show, :edit, :update, :destroy]

  def index
    planned = current_user.live_schedules.planned.order(:date)
    @next_live = planned.first
    @upcoming_lives = planned.offset(1).limit(3)
    recent_scope = current_user.live_schedules.attended.order(date: :desc)
    if @next_live.present?
      @upcoming_lives = planned.where.not(id: @next_live.id).limit(3)
      recent_scope = recent_scope.where.not(id: @next_live.id)
    end
    @recent_records = recent_scope.limit(3)
  end

  def planned
    sort = params[:sort]
    order_clause = case sort
                   when "date_desc"
                     { date: :desc }
                   when "created_desc"
                     { created_at: :desc }
                   else
                     { date: :asc }
                   end
    @planned_lives = current_user.live_schedules.planned.order(order_clause)
    @sort = sort
  end

  def records
    sort = params[:sort]
    order_clause = case sort
                   when "date_asc"
                     { date: :asc }
                   when "created_desc"
                     { created_at: :desc }
                   else
                     { date: :desc }
                   end
    @record_lives = current_user.live_schedules.attended.order(order_clause)
    @sort = sort
  end

  def show
    @live_schedules = LiveSchedule.find(params[:id])
  end

  def new
    @live_schedule = LiveSchedule.new
    @live_schedule.ticket_status = "未購入"
    @live_schedule.build_venue
  end

  def edit
  end

  def create
    Rails.logger.info "PARAMS_ANNOUNCEMENT_IMAGE=#{params.dig(:live_schedule, :announcement_image).inspect}"
    Rails.logger.info "PARAMS_TIMETABLE=#{params.dig(:live_schedule, :timetable).inspect}"
    @live_schedule = current_user.live_schedules.build(live_schedule_params)

    venue_data = live_schedule_params[:venue_attributes]

    existing_venue = if venue_data[:google_place_id].present?
                       Venue.find_by(name: venue_data[:name], google_place_id: venue_data[:google_place_id], user_id: current_user.id)
                     else
                       Venue.find_by(name: venue_data[:name], user_id: current_user.id)
                     end

    if existing_venue
      @live_schedule.venue = existing_venue
    else
      venue = @live_schedule.build_venue(venue_data)
      venue.user = current_user
    end

    if @live_schedule.name.blank? && @live_schedule.date.present? && @live_schedule.venue&.area.present?
      date_str = @live_schedule.date.strftime("%-m月%-d日")
      @live_schedule.name = "#{date_str} #{@live_schedule.venue.area}"
    end

    if @live_schedule.save
      redirect_to live_schedules_path, notice: "ライブを作成しました。"
    else
      Rails.logger.debug @live_schedule.errors.full_messages
      render :new
    end
  end

  def update
    @live_schedule = LiveSchedule.find(params[:id])

    venue_data = live_schedule_params[:venue_attributes]

    existing_venue = if venue_data[:google_place_id].present?
                       Venue.find_by(name: venue_data[:name], google_place_id: venue_data[:google_place_id], user_id: current_user.id)
                     else
                       Venue.find_by(name: venue_data[:name], user_id: current_user.id)
                     end

    if @live_schedule.name.blank?
      date_str = @live_schedule.date.strftime("%-m月%-d日")
      @live_schedule.name = "#{date_str} #{@live_schedule.venue.area}"
    end

    @live_schedule.assign_attributes(live_schedule_params)

    if existing_venue
      @live_schedule.venue = existing_venue
    else
      venue = @live_schedule.build_venue(venue_data.except(:user, :user_id))
      venue.user = current_user
      unless venue.save
        @live_schedule.errors.add(:venue, "の保存に失敗しました。")
        Rails.logger.debug venue.errors.full_messages
        render :edit and return
      end
    end

    if @live_schedule.save
      redirect_to live_schedules_path
    else
      Rails.logger.debug @live_schedule.errors.full_messages
      render :edit
    end
  end

  def destroy
    @live_schedule.destroy
    redirect_to live_schedules_path, notice: "ライブを削除しました。"
  end

  private

  def set_live_schedule
    @live_schedule = current_user.live_schedules.find(params[:id])
  end

  def date_cannot_be_in_the_future
    return unless date.present? && date > Time.zone.today
    errors.add(:date, "は未来の日付を設定することはできません。")
  end

  def live_schedule_params
    params.require(:live_schedule).permit(:name, :date, :artist_id, :open_time, :start_time, :ticket_status, :ticket_sale_date, :ticket_price, :drink_price, :timetable, :announcement_image, :memo,
                                          venue_attributes: [:id,:name, :google_place_id, :area, :latitude, :longitude])
  end
end
