class ComingController < ApplicationController
             before_filter "setsubdomainasgroup"
  def index
    @subscription = Subscription.new
    @message = nil
    @success = false
  end

  def subscribe
    @success = false
    sub = Subscription.new
    sub.email = params[:email]
    if sub.save
      @message = "Thank you. We will send you an update as soon as we are ready"
      @success = true
    else
      sub.errors.each do |key,value|
        @message = value
        break
      end
    end
    render :index
  end

end
