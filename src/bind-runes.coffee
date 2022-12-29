import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"
import * as Arr from "@dashkite/joy/array"
import * as Val from "@dashkite/joy/value"

register "bind runes", ( _, context ) ->

  { request: { authorization }} = context

  # this is what we'll return
  results = []

  # normalize the authorization field into an array
  authorization = if Type.isArray authorization
    authorization
  else
    [ authorization ]

  # get the batch of credentials that are runes and decode them
  current = do ->
    for credential in authorization when credential.scheme == "rune"
      Arr.first JSON36.decode rune

  # if we have some runes, we'll try to bind them
  if !( Val.isEmpty current )

    # we'll need this for Rune.bind
    secret = await getSecret secret

    # go through the authorization documents that have resolvers
    for authorization in current when !( Val.isEmpty rune.resolvers )

      # only bind runes where we don't already have another rune
      # with the same name, which we assume must be the bound counterpart
      # TODO should we log an error when the counterpart also has resolvers
      if !( current.find ({ name }) -> authorization.name = name )?
        results.push Runes.issue {
          secret
          authorization: await Runes.bind { authorization, context... }
        }
    
    # hash and base64 the resulting bound runes, which will
    # be handled by the policy: our job is done here
    base64 hash "utf8", JSON.stringify await Promise.all bound

  # there were no runes
  else []