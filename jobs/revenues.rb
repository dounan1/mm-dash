HOST = "https://mixandmatch.cn"

VENUES = (21..29).to_a + [31]

PARAMS = { venues: VENUES }

URL = "#{HOST}/api/v1/stats/dashboard"

require 'rest-client'

SCHEDULER.every '10s' do

  response = RestClient.get( URL, {params: PARAMS} )
  data = JSON.parse(response.body)
  revenues = data["revenues"]

  revenues.each do |revenue|
    send_event('revenue-treat-' + revenue["id"].to_s, { current: revenue["treat"] / 100.0 })
    send_event('revenue-self-' + revenue["id"].to_s, { current: revenue["self"] / 100.0 })
    send_event('revenue-day-' + revenue["id"].to_s, { current: revenue["today"] / 100.0 })
    send_event('revenue-week-' + revenue["id"].to_s, { current: revenue["week"] / 100.0 })
  end

end
