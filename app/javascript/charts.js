document.addEventListener('turbolinks:load', function() {
  var chartDataElement = document.getElementById('chart-data');
  if (!chartDataElement) {
    return;
  }

  function getChartData(attribute) {
    var value = chartDataElement.getAttribute(attribute);
    if (!value) {
      return [];
    }
    try {
      return JSON.parse(value);
    } catch (error) {
      return [];
    }
  }

  var genreLabels = getChartData('data-genre-counts-keys');
  var genreData = getChartData('data-genre-counts-values');
  var expenseLabels = getChartData('data-category-expenses-keys');
  var expenseData = getChartData('data-category-expenses-values');
  var quantityLabels = getChartData('data-category-quantities-keys');
  var quantityData = getChartData('data-category-quantities-values');
  var artistAttendanceLabels = getChartData('data-artist-attendance-keys');
  var artistAttendanceValues = getChartData('data-artist-attendance-values');
  var artistAttendanceValuesNum = Array.isArray(artistAttendanceValues)
    ? artistAttendanceValues.map(function(value) { return Number(value) || 0; })
    : [];
  var monthlyLiveLabels = getChartData('data-monthly-live-labels');
  var monthlyLiveData = getChartData('data-monthly-live-counts');
  var weeklyData = getChartData('data-weekly-live-counts');

  var genreCanvas = document.getElementById('myChart');
  if (genreCanvas) {
    var genreCtx = genreCanvas.getContext('2d');
    new Chart(genreCtx, {
        type: 'pie',
        data: {
            labels: genreLabels,
            datasets: [{
                data: genreData,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        }
    });
  }

  var expenseCanvas = document.getElementById('expenseChart');
  if (expenseCanvas) {
    var expenseCtx = expenseCanvas.getContext('2d');
    new Chart(expenseCtx, {
        type: 'pie',
        data: {
            labels: expenseLabels,
            datasets: [{
                data: expenseData,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)'
                ],
                borderWidth: 1
            }]
        }
    });
  }

  var monthlyLiveCanvas = document.getElementById('monthlyLiveChart');
  if (monthlyLiveCanvas) {
    var monthlyLiveCtx = monthlyLiveCanvas.getContext('2d');
    new Chart(monthlyLiveCtx, {
        type: 'bar',
        data: {
            labels: monthlyLiveLabels,
            datasets: [{
                label: 'ライブ数',
                data: monthlyLiveData,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
  }

  var weeklyCanvas = document.getElementById('weeklyChart');
  if (weeklyCanvas) {
    var weeklyCtx = weeklyCanvas.getContext('2d');
    new Chart(weeklyCtx, {
        type: 'bar',
        data: {
            labels: ['日', '月', '火', '水', '木', '金', '土'],
            datasets: [{
                label: '曜日別ライブ数',
                data: weeklyData,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
  }

  var quantityCanvas = document.getElementById('categoryQuantityChart');
  if (quantityCanvas) {
    var quantityCtx = quantityCanvas.getContext('2d');
    new Chart(quantityCtx, {
        type: 'bar',
        data: {
            labels: quantityLabels,
            datasets: [{
                label: '購入点数',
                data: quantityData,
                backgroundColor: 'rgba(26, 115, 232, 0.18)',
                borderColor: 'rgba(26, 115, 232, 0.6)',
                borderWidth: 1
            }]
        },
        options: {
            maintainAspectRatio: false,
            indexAxis: 'y',
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        precision: 0
                    }
                }
            }
        }
    });
  }

  var artistAttendanceCanvas = document.getElementById('artistAttendanceChart');
  if (artistAttendanceCanvas) {
    var barHeight = 32;
    var barCount = Array.isArray(artistAttendanceLabels) ? artistAttendanceLabels.length : 0;
    var targetHeight = Math.max(220, Math.min(520, barCount * barHeight));
    var attendanceContainer = artistAttendanceCanvas.parentElement;
    if (attendanceContainer) {
      attendanceContainer.style.height = targetHeight + 'px';
    }
    var attendanceMax = Math.max(3, Math.max.apply(null, artistAttendanceValuesNum.length ? artistAttendanceValuesNum : [0]));
    var artistAttendanceCtx = artistAttendanceCanvas.getContext('2d');
    new Chart(artistAttendanceCtx, {
        type: 'bar',
        data: {
            labels: artistAttendanceLabels,
            datasets: [{
                label: '参戦回数',
                data: artistAttendanceValuesNum,
                backgroundColor: 'rgba(26, 115, 232, 0.18)',
                borderColor: 'rgba(26, 115, 232, 0.6)',
                borderWidth: 1,
                maxBarThickness: 22
            }]
        },
        options: {
            maintainAspectRatio: false,
            indexAxis: 'y',
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    min: 0,
                    max: attendanceMax,
                    ticks: {
                        stepSize: 1,
                        precision: 0
                    }
                }
            }
        }
    });
  }
});
