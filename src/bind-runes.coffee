import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"
import * as Arr from "@dashkite/joy/array"
import * as Type from "@dashkite/joy/type"
import * as Val from "@dashkite/joy/value"
import { Authorization } from "@dashkite/http-headers"

secret = undefined

hasResolvers = ({ resolvers }) ->
  resolvers? && !( Val.isEmpty Object.keys resolvers )

register "bind runes", ( value, context ) ->

  { request } = context

  # normalize the authorization field into an array
  authorizations = if Type.isArray request.authorization
    request.authorization
  else
    [ request.authorization ]

  # get the batch of credentials that are runes and decode them
  current = do ->
    for authorization in authorizations when authorization.scheme == "rune"
      Arr.first Runes.decode authorization.parameters.rune

  # if we have some runes, we'll try to bind them
  if !( Val.isEmpty current )

    # we'll need this for Rune.bind
    secret ?= await getSecret value.secret

    # go through the authorization documents that have resolvers
    results = for authorization in current when hasResolvers authorization
      console.log "BINDING RUNE", authorization
      authorization.expires = value.expires
      credential = await Runes.issue {
        secret
        authorization: await Runes.bind authorization, context
      }
      Authorization.format
        scheme: "rune"
        parameters: credential
    
    # encode the resulting bound runes, which will
    # be handled by the policy: our job is done here
    if results.length > 0
      results
