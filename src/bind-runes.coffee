import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"
import * as Arr from "@dashkite/joy/array"
import * as Type from "@dashkite/joy/type"
import * as Val from "@dashkite/joy/value"
import { json64 } from "./helpers"

register "bind runes", ({ secret }, context ) ->

  { request } = context

  # this is what we'll return
  results = []

  # normalize the authorization field into an array
  authorizations = if Type.isArray request.authorization
    request.authorization
  else
    [ request.authorization ]

  # get the batch of credentials that are runes and decode them
  current = do ->
    for authorization in authorizations when authorization.scheme == "rune"
      Arr.first Runes.decode authorization.credential

  # if we have some runes, we'll try to bind them
  if !( Val.isEmpty current )

    # we'll need this for Rune.bind
    secret = await getSecret secret

    # go through the authorization documents that have resolvers
    for authorization in current when !(Val.isEmpty authorization.resolvers )

      # only bind runes where we don't already have another rune
      # with the same name, which we assume must be the bound counterpart
      # TODO should we log an error when the counterpart also has resolvers
      if !( current.find ({ name }) -> authorization.name = name )?
        results.push Runes.issue {
          secret
          authorization: await Runes.bind { authorization, context... }
        }
    
    # encode the resulting bound runes, which will
    # be handled by the policy: our job is done here
    json64 await Promise.all results

  # there were no runes
  else []