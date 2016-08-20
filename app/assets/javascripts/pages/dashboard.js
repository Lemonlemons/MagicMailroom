// Flot Charts
var chart_border_color = "#efefef";
var chart_color = "#b0b3e3";

var lineOptions = {
	xaxis : {
		mode : "time",
		tickLength : 10
	},
	series : {
		lines : {
			show : true,
			lineWidth : 2,
			fill : true,
			fillColor : {
				colors : [{
					opacity : 0.04
				}, {
					opacity : 0.1
				}]
			}
		},
		shadowSize : 0
	},
	selection : {
		mode : "x"
	},
	grid : {
		hoverable : true,
		clickable : true,
		tickColor : chart_border_color,
		borderWidth : 0,
		borderColor : chart_border_color,
	},
	tooltip : true,
	colors : [chart_color]
};

var barOptions = {
	yaxes: {
				min: 0
		},
	xaxis : {
		mode : "time",
		timeformat: "%a %d"
	},
	series : {
		bars : {
			show : true,
			lineWidth: 0,
			barWidth: 47000000, // for bar charts, this is width in milliseconds (86400000 would be the width of a day)
			align: 'center',
			fillColor : {
				colors : [{ opacity : 0.7 }, { opacity : 0.7 }]
			}
		}
	},
	grid : {
		show: true,
		hoverable : true,
		clickable : true,
		tickColor : chart_border_color,
		borderWidth : 0,
		borderColor : chart_border_color,
	},
	tooltip : true,
	tooltipOpts : {
		content : "Visits on <b>%x</b>: <span class='value'>%y</span>",
		defaultTheme : false,
		shifts: {
			x: -65,
			y: -70
		}
	},
	colors : ["#4fa3d5"]
};

var page_scripts = function () {
	if (!$("#dashboard").length) return;

};

$(document).on("turbolinks:load", page_scripts);
