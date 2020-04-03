_ = require 'lodash'
{parse, format} = require 'url'
token = null

hash = new URLSearchParams window.location.hash?[1..]
if hash.get('access_token')?
  token = hash.get 'access_token'

providers =
  github:
    authorization: ({url, client_id}={}) ->
      url ?= process.env.GITHUB_AUTH_URL || 'https://github.com/login/oauth/authorize'
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
      url ?= process.env.GOOGLE_AUTH_URL || 'https://accounts.google.com/o/oauth2/v2/auth'
      client_id: process.env.GOOGLE_CLIENT_ID
      cb = process.env.GOOGLE_CB
      scope = 'email'
      url = parse url
      url = _.extend url,
        query:
          client_id: client_id
          response_type: 'code'
          redirect_url: cb
          scope: scope
      window.location.replace format url
     
    email: ->

export default 
  providers: providers
  fetch: (url, opts={}) ->
    if token?
      opts = _.defaultsDeep opts,
        headers:
          Authorization: "Bearer #{token}"
    await fetch url, opts
