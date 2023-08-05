class ProfilesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
  	@profile = Profile.new(profile_params)

  	if @profile.save
  	  notify_third_party_apis(:create,@profile)
  	  render json: @profile, status: :created
  	else
  	  render json: @profile.errors, status: :unprocessable_entity
    end
  end

  def update
  	@profile = Profile.find(params[:id])

  	if @profile.update(profile_params)
  	  notify_third_party_apis(:update,@profile)
  	  render json: @profile, status: :ok
  	else
  	  render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private

  def profile_params
  	params.require(:profile).permit(:name,:age)
  end

  def notify_third_party_apis(action,data)
  	secret_key = Rails.application.credentials.webhook_secret_key
  	endpoints = Rails.configuration.x.endpoints
  	events = Rails.configuration.x.events
  	endpoints.each do|endpoint_name, endpoint_url|
  	  event = events.dig(endpoint_name,action)
      next unless event
      
      begin
        self.send(event,data)
      rescue NoMethodError => e
      	Rails.logger.error("Method #{event} not defined for #{endpoint_name} : #{e.message}")
      end
      signature = data.webhook_signature(secret_key)
      payload = {name: data.name, age: data.age, signature: signature}
      response = HTTParty.post(endpoint_url, headers: {'X-Webhook-Signature': signature }, body: payload.to_json)
      if response.success?
        Rails.logger.info("Notified #{endpoint_name} Successfully")
      else
        Rails.logger.error("Failed to notify #{endpoint_name}: #{response.code} - #{response.body}")
      end
  	end
  end

  def notify_api1_on_create(data)
  	puts "Notified about change data: #{data}"
  end

   def notify_api1_on_update(data)
   	puts "Notified about change data: #{data}"
  end

   def notify_api2_on_create(data)
   	puts "Notified about change data: #{data}"
  end
end
