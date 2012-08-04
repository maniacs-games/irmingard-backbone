'use strict'

# override Marionette's Renderer.render to allow usage of JST templates (HAML coffee in our case)
# cf. https://github.com/derickbailey/backbone.marionette/wiki/Using-jst-templates-with-marionette
Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template '" + template + "' not found!" unless JST[template]
  JST[template](data)

# initialise app and set namespace
window.IG = new Backbone.Marionette.Application()

IG.Models      = {}
IG.Collections = {}
IG.Routers     = {}
IG.Views       = {}
IG.Controllers = {}

IG.addRegions
  contentRegion: '#l-content'

IG.vent = new Backbone.Marionette.EventAggregator()

AppLayout = Backbone.Marionette.Layout.extend
  template: JST['layouts/application']
  regions:
    #menu: "#l-navigation"
    content: "#l-content"

IG.addInitializer (option) ->
  IG.appRouter = new IG.Routers.AppRouter()
  Backbone.history.start
    pushState: true
  #IG.Controllers.deals = new IG.Controllers.Deals()
  #IG.Controllers.pages = new IG.Controllers.Pages()
  #IG.vent.bind 'enterDealsShow', IG.Controllers.deals.enterShow

  appLayout = new AppLayout()
  appLayout.render()
  gamesShow = IG.contentRegion.show new IG.Views.GamesShow()

$ ->
  IG.start()