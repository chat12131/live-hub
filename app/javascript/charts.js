document.addEventListener('turbolinks:load', function() {
  var chartDataElement = document.getElementById('chart-data');
  if (!chartDataElement) {
    return;
  }

  function getChartData(attribute) {
    return JSON.parse(chartDataElement.getAttribute(attribute));
  }

  var genreLabels = getChartData('data-genre-counts-keys');
  var genreData = getChartData('data-genre-counts-values');
  var expenseLabels = getChartData('data-category-expenses-keys');
  var expenseData = getChartData('data-category-expenses-values');
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
});
