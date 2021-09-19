class EventsController < ApplicationController
before_action :set_event, only:[:edit, :update, :destroy]
skip_before_action :authenticate, only:[:show]

  def show
    @event = Event.find(params[:id])
    @ticket = Ticket.new
    @created_ticket = current_user && current_user.tickets.find_by(event: @event)
    @tickets = @event.tickets.includes(:user).order(:created_at)
  end

  def new
    @event = current_user.created_events.build
  end

  def create
  @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to @event, notice: "作成しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "編集しました"
    else
      render :edit
    end
  end

  def destroy
    @event.destroy!
    redirect_to root_path, notice:"削除しました"
  end

  private

  def event_params
    params.require(:event).permit(:name, :place, :content, :image, :remove_image, :start_at, :end_at)
  end

  def set_event
    @event = current_user.created_events.find(params[:id])
  end

end
