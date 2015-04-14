head = document.getElementsByTagName('head')[0]
script = document.createElement('script')
script.type = 'text/javascript'
script.src = 'https://apis.google.com/js/client.js?onload=onClientLoad'
head.appendChild script
youTubeAPILoaded = false
pendingRequest = null

window.onClientLoad = ->
  gapi.client.load 'youtube', 'v3', onYouTubeApiLoad

onYouTubeApiLoad = ->
  gapi.client.setApiKey 'AIzaSyD-EBWXZnauyJ_NvUPyeNX5m8kJswEEe-I'
  youTubeAPILoaded = true
  console.log "onYouTubeApiLoad"
  if pendingRequest != null
    pendingRequest()

searchYoutube = (query, callback) ->
  if !youTubeAPILoaded
    pendingRequest = ->
      searchYoutbe query, callback
    return

  request = gapi.client.youtube.search.list(
    part: 'snippet'
    q: query)
  request.execute callback

searchRequestListener = (request, sender, sendResponse) ->
  if request.event != 'search'
    return false
  title = request.title
  console.log 'On request of searching ' + title

  onSearchResponse = (response) ->
    itemList = response['items']
    console.log itemList
    console.log sendResponse
    sendResponse itemList

  searchYoutube title, onSearchResponse
  true

optionRequestListener = (request, sender, sendResponse) ->
  if request.event != 'load'
    return false
  getIsActive (isActive) ->
    sendResponse isActive
  true

getIsActive = (callback) ->
  chrome.storage.sync.get 'active', (savedItems) ->
    isActive = true
    if 'active' of savedItems and ! savedItems['active']
      isActive = false
    callback isActive
  
setBrowserActionIcon = (isActive) ->
  if isActive
    icon = path: 'images/browser_action_normal.png'
  else
    icon = path: 'images/browser_action_disabled.png'
  chrome.browserAction.setIcon icon

chrome.runtime.onMessage.addListener searchRequestListener
chrome.runtime.onMessage.addListener optionRequestListener
chrome.browserAction.onClicked.addListener (tab) ->
  getIsActive (isActive) ->
    isActive = !isActive
    chrome.storage.sync.set 'active': isActive
    setBrowserActionIcon isActive
    
getIsActive (isActive) ->
  setBrowserActionIcon isActive
