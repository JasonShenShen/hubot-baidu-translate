queryword = 'a senior official in north China\'s Shanxi Province is under investigation after being suspected of accepting bribes'
http = require('http')
querystring = require('querystring')

translate = (params, callback) ->
  if typeof params == 'string'
    params = query: params
  params =
    from: params.from or 'zh'
    to: params.to or 'en'
    query: params.query or ''
  data = querystring.stringify(params)
  options =
    host: 'fanyi.baidu.com'
    port: 80
    path: '/v2transapi'
    method: 'POST'
    headers:
      'Content-Type': 'application/x-www-form-urlencoded'
      'Content-Length': data.length
  req = http.request(options, (res) ->
    result = ''
    res.setEncoding 'utf8'
    res.on 'data', (data) ->
      result += data
      return
    res.on 'end', ->
      obj = JSON.parse(result)
      str = obj.trans_result.data[0].dst
      callback str
      return
    return
  )
  req.on 'error', (err) ->
    console.log err
    setTimeout (->
      translation query, callback
      return
    ), 3000
    return
  req.write data
  req.end()
  return

translate {
  from: 'en'
  to: 'zh'
  query: queryword
}, (result) ->
  console.log result
  return
