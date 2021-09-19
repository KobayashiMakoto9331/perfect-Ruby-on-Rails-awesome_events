class TicketsController < ApplicationController

  def new
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)
    if @ticket.save
      redirect_to root_path, notice:"イベントに参加しました"
    end
  end
  
  def destroy
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    ticket.destroy!
    redirect_to event_path(params[:event_id])
  end

  private

  def ticket_params
    params.require(:ticket).permit(:comment).merge(event_id: params[:event_id])
  end

end
