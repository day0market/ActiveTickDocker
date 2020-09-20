# ActiveTick quote server

This is dockerized ActiveTick HTTP quote server with health checks and auto healing. 
Auto healing uses https://github.com/willfarrell/docker-autoheal docker image.

## How auto healing works in this case
ActiveTick HTTP server always return 200 HTTP code even if we have disconnect or duplicate login status. Health check script
make requests for specific URI and checks response body. If body doesn't contain particular time string
than container is not healthy and we have to restart it. You can find more details about auto healing setup in 
Will Farrell docs.

## How to use it

* Create `.env` file with your ActiveTick credentials. Use `.env_sample` as a template
* Build it `docker-compose build`
* Start services `docker-compose up`
* Open your browser, check `http://127.0.0.1:YOUR_PORT_FROM_SETTINGS/barData?symbol=MSFT&historyType=0&intradayMinutes=10&beginTime=20101103093000&endTime=20101103160000` and you should see some MSFT quotes
* Have fun

You can also change health check settings and auto healing interval per your needs.

In case you're Russian speaking guy join my telegram [channel](https://t.me/day0market) and my [blog](https://day0markets.ru/) about algo trading. 
