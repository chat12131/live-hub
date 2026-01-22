document.addEventListener('turbolinks:load', function() {
  resetWeatherVariables();
  var API_KEY = $('#weather-section').data('weather-api-key');
  var latitude = $('#weather-section').data('latitude');
  var longitude = $('#weather-section').data('longitude');

  if (!latitude || !longitude) {
    $('#weather-section').remove();
    return;
  }

  var item_id = 'lat=' + latitude + '&lon=' + longitude;
  var url = 'https://api.openweathermap.org/data/2.5/forecast?' + item_id + '&lang=ja&units=metric&appid=' + API_KEY;

  $.ajax({
    url: url,
    dataType: 'json',
    type: 'GET',
  })
  .done(function(data) {
    var insertHTML = buildWeatherReport(data);
    if (insertHTML) {
      $('#weather-report-area').html(insertHTML);
    } else {
      $('#weather-section').remove();
    }
  })
  .fail(function() {
    $('#weather-section').remove();
  });
});

function resetWeatherVariables() {
  targetWeather = null;
  $('#weather-report-area').empty();
}

function buildWeatherReport(data) {
  var liveScheduleDate = new Date($('#live-schedule-date').data('date'));

  var targetTime = $('#live-time-info').data('time');
  var targetHour = parseInt(targetTime.split(':')[0], 10);

  var nearestDiff = Number.MAX_VALUE;

  for (var i = 0; i < data.list.length; i++) {
    var weatherDate = new Date(data.list[i].dt_txt);

    if (liveScheduleDate.getDate() === weatherDate.getDate() &&
        liveScheduleDate.getMonth() === weatherDate.getMonth() &&
        liveScheduleDate.getFullYear() === weatherDate.getFullYear()) {

      var hourDiff = Math.abs(weatherDate.getHours() - targetHour);

      if(hourDiff < nearestDiff) {
        nearestDiff = hourDiff;
        targetWeather = data.list[i];
      }
    }
  }


  if (!targetWeather) {
    return ;
  }

  var icon = targetWeather.weather[0].icon.replace('n', 'd');
  var precipitationProbability = targetWeather.pop ? (targetWeather.pop * 100) : 0;

  var html =
  `<div class='weather-report'>
     <img src='https://openweathermap.org/img/w/${icon}.png'>
     <div class='weather-temp'>${Math.round(targetWeather.main.temp)}℃</div>
     <div class='weather-precipitation'>降水確率: ${precipitationProbability}%</div>
  </div>`;

  return html;
}
