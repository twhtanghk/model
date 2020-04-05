_ = require 'lodash'
{promisify} = require 'bluebird'
{request} = require 'needle'
request = promisify request
{parse, format} = require 'url'

class OAuth2
  url:
    auth: ''
    token: ''
    cb: ''
    user: ''

  client:
    id: ''
    secret: ''

  scope: []

  constructor: ({@url, @client, @scope} = {}) ->

  authorization: ->
    query =
      client_id: @client.id
      response_type: 'code'
      redirect_uri: @url.cb
      scope: @scope
    url = parse @url.auth
    url = _.extend url, {query}
    window.location.replace format url

  token: (code) ->
    params =
      client_id: @client.id
      client_secret: @client.secret
      code: code
      grant_type: 'authorization_code'
      redirect_uri: @url.cb
    {body} = await request 'post', @url.token, params, json: true
    {URLSearchParams} = require 'url'
    new URLSearchParams body

  email: (token) ->
    {body} = await request 'get', @url.user, {},
      headers:
        Authorization: "Bearer #{token}"
    body

class Github extends OAuth2
  constructor: ({url, client, scope} = {}) ->
    super arguments
    _.defaultsDeep @,
      url:
        auth: process.env.GITHUB_AUTH_URL || 'https://github.com/login/oauth/authorize'
        token: process.env.GITHUB_TOKEN_URL || 'https://github.com/login/oauth/access_token'
        cb: process.env.GITHUB_CB_URL
        user: process.env.GITHUB_USER_URL || 'https://api.github.com/user'
      client:
        id: process.env.GITHUB_CLIENT_ID
        secret: process.env.GITHUB_CLIENT_SECRET
      scope: []

class Google extends OAuth2
  constructor: ({url, client, scope} = {}) ->
    super arguments
    _.defaultsDeep @,
      url:
        auth: process.env.GOOGLE_AUTH_URL || 'https://accounts.google.com/o/oauth2/v2/auth'
        token: process.env.GOOGLE_TOKEN_URL || 'https://oauth2.googleapis.com/token'
        cb: process.env.GOOGLE_CB_URL
        user: process.env.GOOGLE_USER_URL || 'https://www.googleapis.com/oauth2/v1/tokeninfo'
      client:
        id: process.env.GOOGLE_CLIENT_ID
        secret: process.env.GOOGLE_CLIENT_SECRET
      scope: ['https://www.googleapis.com/auth/userinfo.email']

token = null

module.exports =
  providers:
    google: new Google()
    github: new Github()
  fetch: (url, opts={}) ->
    hash = new URLSearchParams window.location.hash?[1..]
    if hash.get('access_token')?
      token = hash.get 'access_token'
    if token?
      opts = _.defaultsDeep opts,
        headers:
          Authorization: "Bearer #{token}"
    await fetch url, opts
