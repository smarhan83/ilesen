
function init_chart_bar1(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat1').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketByDepartment",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat1').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Department'
                    }
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar2(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat2').length) {        

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketMonthly",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];
            var aDatasets2 = aData[2];
            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',//"Bunches",
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(184,11,46,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(184,11,46,1)',
                    data: aDatasets1,
                    tension: 0.1,
                    fill: false,
                    pointStyle:'star'
                }
                ]
            };

            var barChartCanvas = $('#chartStat2').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'line',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Month'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar3(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat3').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketByCategory",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];
            

            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat3').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Category'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar4(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat4').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketByPriority",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat4').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Priority'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar5(actYearID, actMonthID, departmentID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStatA1').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            Department: departmentID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotHardwareByCategory",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Asset',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStatA1').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Hardware By Category'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar6(actYearID, actMonthID, departmentID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStatA2').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            Department: departmentID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotSoftwareByCategory",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Asset',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStatA2').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Software By Category'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar7(actYearID, actMonthID, departmentID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStatA3').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            Department: departmentID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotSoftwareOS",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Asset',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStatA3').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total OS Software By Version'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar8(actYearID, actMonthID, departmentID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStatA4').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            Department: departmentID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotSoftwareMOffice",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Asset',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStatA4').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Microsoft Office Software By Version'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar9(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat5').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketByPIC",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat5').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket Solved by Agent'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar10(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat6').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotRating",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat6').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket Rating'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar11(actYearID, actMonthID, ticketTypeID, ticketCategoryID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat7').length) {

        var jsonData = JSON.stringify({
            ActYear: actYearID,
            ActMonth: actMonthID,
            TicketType: ticketTypeID,
            TicketCategory: ticketCategoryID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotReview",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Review/Comment',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat7').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'doughnut',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Review/Comment'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar12(empID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat8').length) {

        var jsonData = JSON.stringify({
            EmpID : empID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketMonthlyInd",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];
            var aDatasets2 = aData[2];
            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',//"Bunches",
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(184,11,46,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(184,11,46,1)',
                    data: aDatasets1,
                    tension: 0.1,
                    fill: false,
                    pointStyle: 'star'
                }
                ]
            };

            var barChartCanvas = $('#chartStat8').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'line',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Month'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar13(empID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat9').length) {

        var jsonData = JSON.stringify({
            EmpID: empID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketByCategoryIndv",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat9').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Category'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar14(empID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat10').length) {

        var jsonData = JSON.stringify({
            EmpID: empID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotTicketByPriorityIndv",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat10').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket By Priority'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

function init_chart_bar15(empID) {
    if (typeof (Chart) === 'undefined') { return; }

    if ($('#chartStat11').length) {

        var jsonData = JSON.stringify({
            EmpID: empID
        });

        $.ajax({
            type: "POST",
            url: "DashboardService.asmx/getChartTotRatingIndv",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess_,
            error: OnErrorCall_
        });
        function OnSuccess_(reponse) {
            var aData = reponse.d;
            var aLabels = aData[0];
            var aDatasets1 = aData[1];


            var areaChartData = {
                labels: aLabels,
                datasets: [{
                    label: 'Total Ticket',
                    backgroundColor: '#fcd34d',
                    borderColor: '#fcd34d',
                    pointRadius: false,
                    pointColor: '#3b8bba',
                    pointStrokeColor: 'rgba(17,246,176,1)',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(17,246,176,1)',
                    data: aDatasets1
                }
                ]
            };

            var barChartCanvas = $('#chartStat11').get(0).getContext('2d')
            var barChartData = jQuery.extend(true, {}, areaChartData)
            var temp0 = areaChartData.datasets[0]
            barChartData.datasets[0] = temp0
            var barChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                datasetFill: false
            }

            var barChart = new Chart(barChartCanvas, {
                type: 'bar',
                data: barChartData,
                options: {
                    barChartOptions,
                    title: {
                        display: true,
                        text: 'Total Ticket Rating'
                    }
                }
            })
        }
        function OnErrorCall_(repo) {
            console.log(repo);
            alert("Woops something went wrong, pls try later !");
        }
    }
}

$(document).ready(function () {
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    var ActYear = selectedYear.value;
    var ActMonth = selectedMonth.value;
    var TicketType = ticketType.value;
    var TicketCategory = ticketCategory.value;
    var AssetStatus = assetStatus.value;
    var Department = departmentID.value;
    var EmpID = empID.value;
    //var Year = 9999;
    //var Month = 9999;
    //var TicketType = 9999;
    //var TicketCategory = 9999;

    //var EstateID = OCID.value;
    //var actMthYearID = ActMthYear.value;
    //var d = new Date();
    //var curYear = lstYear.value;//d.getFullYear();
    //var curMonth = lstMth.value - 1;//d.getMonth();
    //var curMonthName = monthNames[curMonth];

    //init_chart_bar1(Year, Month, TicketType, TicketCategory);
    init_chart_bar1(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar2(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar3(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar4(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar5(ActYear, ActMonth, Department);
    init_chart_bar6(ActYear, ActMonth, Department);
    init_chart_bar7(ActYear, ActMonth, Department);
    init_chart_bar8(ActYear, ActMonth, Department);
    init_chart_bar9(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar10(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar11(ActYear, ActMonth, TicketType, TicketCategory);
    init_chart_bar12(EmpID);
    init_chart_bar13(EmpID);
    init_chart_bar14(EmpID);
    init_chart_bar15(EmpID);
    //init_chart_bar2(EstateID);
    //console.log(EstateID);
    //console.log(curMonth);
    //console.log(curYear);
});