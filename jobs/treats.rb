TREAT_URL = "#{HOST}/api/v1/treats/stats"

require 'rest-client'

SCHEDULER.every '10s' do

  response = RestClient.get( TREAT_URL, {params: PARAMS} )
  data = JSON.parse(response.body)
  treats = data["recent_treats"]

  if treats.any?

    venue_treats = treats.group_by do |treat|
      treat["venue_id"]
    end

    venue_treats.each do |venue, treats|

      items = []
      treats.each do |treat|

        status = treat["status"]
        giver = treat["user"]["username"]
        receiver = treat["receiver"]["username"]
        drink = treat["drink"]["name"]
        price = treat["drink"]["price"] / 100
        type = treat["user"]["id"] == treat["receiver"]["id"] ? 'Self' : 'Mutual'
        day = DateTime.parse(treat["redeemed_at"]).strftime('%A, %b %d')
        time = DateTime.parse(treat["redeemed_at"]).strftime('%I:%M:%S %p')

        label = "#{drink.ljust(10)}           #{giver.ljust(10)} ⇰ #{receiver.ljust(10)}           #{type.ljust(10)}           #{day.ljust(10)}           #{time.ljust(10)}"

        items << { label: label, value: "¥#{price}" }
      end

      send_event("treats-#{venue}", { items: items })

    end


  end
end
