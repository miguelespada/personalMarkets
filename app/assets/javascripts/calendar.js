//= require d3
//= require cal-heatmap
 
$( document ).ready(function() {
	var date1 = new Date(2014, 2, 25);
	var date11 = Date.parse(date1)/1000;
	var date2 = new Date(2014, 3, 15);
	var date22 = Date.parse(date2)/1000;
	var date3 = new Date(2014, 4, 25);
	var date33 = Date.parse(date3)/1000;
	console.log(date11, date22, date33);
	var datas = [
	{date: 1395702000, value: 20},
	{date: 1397512800, value: 45},
	{date: 1400968800, value: 90}
];
var parser = function(data) {
	var stats = {};
	for (var d in data) {
		stats[data[d].date] = data[d].value;
	}
	return stats;
};
	var date = new Date();
	var calweek = new CalHeatMap();
	calweek.init({
		itemSelector : "#calweek",
		start: new Date(date.getFullYear(), date.getMonth(), date.getDate()),
		id : "graph_day",
		domain : "day",
		subDomain: "hour",
		cellSize: 20,
		cellPadding: 5,
		range : 7,
		domainGutter: 15,
		scale: [40, 60, 80, 100]
	});

	var calmonth = new CalHeatMap();
	calmonth.init({
		itemSelector : "#calmonth",
		data: datas,
		afterLoadData: parser,
		start: new Date(date.getFullYear(), date.getMonth()),
		id : "graph_month",
		domain : "month",
		subDomain: "x_day",
		subDomainTextFormat: "%d",
		cellSize: 30,
		cellPadding: 5,
		range : 3,
		domainGutter: 27.5,
		scale: [40, 60, 80, 100]
	});
});
