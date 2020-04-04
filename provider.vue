<template>
  <div class="text-center">
    <v-dialog
      v-model="visible"
      width="500"
    >
      <v-card>
        <v-card-title
          class="headline grey lighten-2"
          primary-title
        >
          Trusted OAuth2 Providers
        </v-card-title>

        <v-card-text>
          <v-btn icon small color='blue' v-for='(provider, i) in providers' :key='i' @click='provider.authorization()'>
            <v-icon>
              {{provider.icon}}
            </v-icon>
          </v-btn>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang='coffee'>
import {mdiGoogle, mdiGithub} from '@mdi/js'
{providers} = require './oauth2.coffee'
for k,v of providers
  switch k
    when 'google'
      providers[k].icon = mdiGoogle
    when 'github'
      providers[k].icon = mdiGithub
 
export default
  props:
    dialog:
      type: Boolean
  data: ->
    providers: providers
  computed:
    visible:
      get: ->
        @dialog
      set: (value) ->
        @$emit 'update:dialog', value
</script>
