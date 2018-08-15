# HOST = "http://localhost:3000"
HOST = "https://mixandmatch.cn"
URL = "#{HOST}/api/v1/stats/dashboard"
VENUE = 14

require 'rest-client'

points = []
last_view = 0
last_revenue_treat = 0
last_revenue_self = 0
last_min = Time.now.min

SCHEDULER.every '5s' do

  response = RestClient.get( URL, params: { venue_id: VENUE } )
  data = JSON.parse(response.body)
  # views = data["views"]
  # gender = data["gender"]
  # users = data["users"]
  revenues = data["revenues"]

  # min == Time.now.min ? points.pop : points.shift

  # points << { x: min, y: users }

  # send_event('views', { current: views, last: last_view })
  # send_event('gender',   { value: gender })
  # send_event('users', points: points)
  send_event('revenue-treat', { current: revenues["treat"] / 100.0 , last: last_revenue_treat })
  send_event('revenue-self', { current: revenues["self"] / 100.0, last: last_revenue_self })

  # percent changes in graphs are caculated by the minute
  if Time.now.min == last_min
    last_min = Time.now.min
    # last_view = views
    last_revenue_treat = revenues["treat"] / 100.0
    last_revenue_self = revenues["self"] / 100.0
  end
end
