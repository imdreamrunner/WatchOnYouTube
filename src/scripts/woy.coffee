web_dict =
  '//v.youku.com/': 'YOUKU'
  '//www.tudou.com/programs/view/': 'TUDOU'
  '//www.tudou.com/albumplay/': 'TUDOU'

youtube_prefix = 'https://www.youtube.com/watch?v='
youtube_seach_prefix = 'https://www.youtube.com/results?search_query='

notice_template =
  """
  <div class="woy-notice">
    <div class="message">
      Similar video found on Youtube!
      <div class="close">Close</div>
    </div>
    <ul class="video-list">
    </ul>
    <div class="more-video">more...</div>
  </div>
  """
  
video_item_template =
  """
  <li>
    <a class="link" href="#" target="_blank">
      <img class="thumbnail">
      <div class="text">
        <div class="title"></div>
        <div class="description"></div>
      </div>
    </a>
  </li>
  """

getSourceWebsite = ->
  url = window.location.href
  for prefix of web_dict
    if url.indexOf(prefix) >= 0
      return web_dict[prefix]

getVideoTitle = ->
  website = getSourceWebsite()
  #console.log website
  if website == null
    return
  switch website
    when 'YOUKU'
      text = $('h1.title:first').text()
    when 'TUDOU'
      text = $('h1#videoKw').text()
  text
      
parseYouTubeItem = (item) ->
  try
    parsed =
      title: item['snippet']['title']
      description: item['snippet']['description']
      url: youtube_prefix + item['id']['videoId']
      thumbnail: item['snippet']['thumbnails']['default']['url']
  catch ex
    #console.log ex
  parsed

moreDisplayed = false
showMoreVideo = (keyword) -> ->
  if ! moreDisplayed
    $('.woy-notice').addClass('more')
    $('.woy-notice').find('.more-video').html "Search on YouTube"
    moreDisplayed = true
  else
    window.open youtube_seach_prefix + keyword
  false

displayNotice = (data, keyword) ->
  $('div.woy-notice').remove()
  $notice = $(notice_template)
  $notice.find('.more-video').click showMoreVideo(keyword)
  $notice.find('.close').click ->
    $notice.hide(500)
  for item in data
    video = parseYouTubeItem item
    if !video
      continue
    $video = $(video_item_template)
    $video.find('.title').html video.title
    $video.find('.description').html video.description
    $video.find('.link').attr 'href', video.url
    $video.find('.thumbnail').attr 'src', video.thumbnail
    $notice.find('.video-list').append $video
  $('body').prepend $notice

requestSearch = ->
  request =
    event: 'load'
  handle = (option) ->
    if option
      doSearching()
  #console.log "send load request"
  chrome.runtime.sendMessage request, handle
  
doSearching = ->
  title = getVideoTitle().trim()
  if title.length == 0
    return
  $('div.woy-notice').remove()
  #console.log 'Send title: ' + title
  sendData = 
    event: 'search'
    title: title

  videoSearchResponse = (data) ->
    #console.log JSON.stringify data
    #console.log data
    if data.length > 0
      displayNotice data, title

  chrome.runtime.sendMessage sendData, videoSearchResponse
  
  # Testing
  #data = [{"kind":"youtube#searchResult","etag":"\"kYnGHzMaBhcGeLrcKRx6PAIUosY/a7VECY77f2z5reFDVFo1lmcfDXk\"","id":{"kind":"youtube#video","videoId":"45eoOLOxINA"},"snippet":{"publishedAt":"2011-08-19T13:39:52.000Z","channelId":"UCE9_O3hd_MFXFVHghfyVl8A","title":"平原绫香独唱天空之城主题曲君をのせて","description":"","thumbnails":{"default":{"url":"https://i.ytimg.com/vi/45eoOLOxINA/default.jpg"},"medium":{"url":"https://i.ytimg.com/vi/45eoOLOxINA/mqdefault.jpg"},"high":{"url":"https://i.ytimg.com/vi/45eoOLOxINA/hqdefault.jpg"}},"channelTitle":"garnet1225","liveBroadcastContent":"none"}},{"kind":"youtube#searchResult","etag":"\"kYnGHzMaBhcGeLrcKRx6PAIUosY/fA39C9_XvuWlmhY1mz9MzZFAuD8\"","id":{"kind":"youtube#video","videoId":"AKMz0qY4ar4"},"snippet":{"publishedAt":"2013-05-10T12:11:38.000Z","channelId":"UCPa9bhzn8BasI8Fx4is1Z6g","title":"久石讓武道館音樂會 - 天空の城 ラピュタ－君をのせて (HD)","description":"一首歌, 喚醒塵封於心底的回憶. 將近1200人的演出四所學校的軍樂隊New Japan Philharmonic World Dream Orchestra 多組專業及業餘合唱團, 300位公開招募的合 ...","thumbnails":{"default":{"url":"https://i.ytimg.com/vi/AKMz0qY4ar4/default.jpg"},"medium":{"url":"https://i.ytimg.com/vi/AKMz0qY4ar4/mqdefault.jpg"},"high":{"url":"https://i.ytimg.com/vi/AKMz0qY4ar4/hqdefault.jpg"}},"channelTitle":"","liveBroadcastContent":"none"}},{"kind":"youtube#searchResult","etag":"\"kYnGHzMaBhcGeLrcKRx6PAIUosY/G2XB5qowoRLQMOkWtZFB5pFzuY4\"","id":{"kind":"youtube#video","videoId":"8xH31dMGX4Y"},"snippet":{"publishedAt":"2010-06-23T12:41:10.000Z","channelId":"UCjTGGLQ4k6jrKMVrDoN_GLw","title":"郭燕-天空之城MV (久石让《天空之城》中文填词版）","description":"久石让《天空之城》中文填词版.","thumbnails":{"default":{"url":"https://i.ytimg.com/vi/8xH31dMGX4Y/default.jpg"},"medium":{"url":"https://i.ytimg.com/vi/8xH31dMGX4Y/mqdefault.jpg"},"high":{"url":"https://i.ytimg.com/vi/8xH31dMGX4Y/hqdefault.jpg"}},"channelTitle":"fountainpark723","liveBroadcastContent":"none"}},{"kind":"youtube#searchResult","etag":"\"kYnGHzMaBhcGeLrcKRx6PAIUosY/zG5WamICAsyUgIua8VOtWtQUhV0\"","id":{"kind":"youtube#video","videoId":"71mqvLrnti8"},"snippet":{"publishedAt":"2013-07-22T03:19:47.000Z","channelId":"UC1uwK4QkeJVCYyUOi7DGBBQ","title":"[sinapremium] 长沙：世界最高楼天空之城动工高838米","description":"[sinapremium] 长沙：世界最高楼天空之城动工高838米.","thumbnails":{"default":{"url":"https://i.ytimg.com/vi/71mqvLrnti8/default.jpg"},"medium":{"url":"https://i.ytimg.com/vi/71mqvLrnti8/mqdefault.jpg"},"high":{"url":"https://i.ytimg.com/vi/71mqvLrnti8/hqdefault.jpg"}},"channelTitle":"sinapremium2013","liveBroadcastContent":"none"}},{"kind":"youtube#searchResult","etag":"\"kYnGHzMaBhcGeLrcKRx6PAIUosY/fWA_7sYC5Xd8mRIGqg0E8eGE_k0\"","id":{"kind":"youtube#video","videoId":"9jbUyDdUmA0"},"snippet":{"publishedAt":"2011-10-23T17:10:37.000Z","channelId":"UCQfvbz-DF-F6IPdSA6SgjQw","title":"在课桌上一根弦弹天空之城！That's how you play a music!","description":"A Chinese students play a song with only a string and a pencil on the desk.","thumbnails":{"default":{"url":"https://i.ytimg.com/vi/9jbUyDdUmA0/default.jpg"},"medium":{"url":"https://i.ytimg.com/vi/9jbUyDdUmA0/mqdefault.jpg"},"high":{"url":"https://i.ytimg.com/vi/9jbUyDdUmA0/hqdefault.jpg"}},"channelTitle":"kangtaer","liveBroadcastContent":"none"}}]
  #keyword = "keyword"
  #console.log keyword
  #displayNotice(data, keyword)

currentTitle = null

checkTitleChange = ->
  newTitle = getVideoTitle()
  if newTitle != currentTitle
    currentTitle = newTitle
    requestSearch()
  setTimeout checkTitleChange, 1000

# $(document).ready requestSearch
checkTitleChange()


# For website (like TuDou) using pushState
# Not working well yet.

#window.addEventListener 'popstate', requestSearch
#
#_pushState = window.history.pushState
#window.history.pushState = ->
  #console.log "inject pushState"
  #requestSearch()
  #_pushState.apply(this, arguments)

