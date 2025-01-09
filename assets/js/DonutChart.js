export default {
  mounted() {
    const ctx = document.getElementById('donutChart').getContext('2d');
    const data = JSON.parse(this.el.dataset.chartData); // Load data from `data-chart-data` attribute.
    
    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: data.labels,
        datasets: [{
          data: data.values,
          backgroundColor: data.colors,
          borderColor: '#fff',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            display: false
          },
        }
      }
    });
  }
}
