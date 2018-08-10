TREAT_URL = "#{HOST}/api/v1/treats/stats"

require 'rest-client'

SCHEDULER.every '10s' do

  response = RestClient.get( TREAT_URL, params: { venue_id: VENUE } )
  data = JSON.parse(response.body)
  treats = data["recent_treats"]

  if treats.any?

    treats.map! do |treat|
      status = treat["status"]
      giver = treat["user"]["username"]
      receiver = treat["receiver"]["username"]
      drink = treat["drink"]["name"]

      if status == "offered"
        { label: "#{giver} ⇰ #{receiver}: #{drink}", value: status }
      else
        { label: "#{giver} ⇰ #{receiver}: #{drink}", value: status }
      end

    end


    send_event('treats', { items: treats })

  end
end
