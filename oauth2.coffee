_ = require 'lodash'
{parse, format} = require 'url'
token = null

hash = new URLSearchParams window.location.hash?[1..]
if hash.get('access_token')?
  token = hash.get 'access_token'

export default 
  providers:
    github:
      authorization: ({url, client_id}={}) ->
        url ?= process.env.GITHUB_AUTH_URL
        client_id ?= process.env.GITHUB_CLIENT_ID
        url = parse url
        url = _.extend url,
          query:
            client_id: client_id
            response_type: 'code'
        window.location.replace format url
      email: ->

    google:
      authorization: ({url, client_id}={}) ->
        github.authorization
          url: process.env.GOOGLE_AUTH_URL
          client_id: process.env.GOOGLE_CLIENT_ID
      email: ->

  fetch: (url, opts={}) ->
    if token?
      opts = _.defaultsDeep opts,
        headers:
          Authorization: "Bearer #{token}"
    await fetch url, opts
