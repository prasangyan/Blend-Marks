class ComingController < ApplicationController

  def index
    @subscription = Subscription.new
    @message = nil
  end

  def subscribe

    sub = Subscription.new
    sub.email = params[:email]
    if sub.save
      @message = "Thank you. We will send you an update as soon as we are ready"
    else
      sub.errors.each do |key,value|
        @message = value
        break
      end
    end
    render :index
  end

end
