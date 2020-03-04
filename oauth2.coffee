_ = require 'lodash'
{parse, format} = require 'url'
token = null

hash = new URLSearchParams window.location.hash?[1..]
if hash.get('access_token')?
  token = hash.get 'access_token'

github =
  authorization: ({url, client_id}={}) ->
    url ?= process.env.AUTH_URL
    client_id ?= process.env.CLIENT_ID
    url = parse url
    url = _.extend url,
      query:
        client_id: client_id
        response_type: 'code'
    window.location.replace format url

export default fetch: (url, opts={}) ->
  if token?
    opts = _.defaultsDeep opts,
      headers:
        Authorization: "Bearer #{token}"
  res = await fetch url, opts
  if res.status == 401
    github.authorization()
  res
