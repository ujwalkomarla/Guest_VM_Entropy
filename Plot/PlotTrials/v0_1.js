//Reference: Source:http://bl.ocks.org/DStruths/9c042e3a6b66048b5bd4

//http://stackoverflow.com/questions/13053935/importing-multiple-csv-files-in-javascript

var margin = {top: 20, right: 200, bottom: 20, left: 50},
    marginBrush = { top: 20, right: 200, bottom: 20, left: 50 },
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom,
    heightBrush = 100 - marginBrush.top - marginBrush.bottom;

//Change Script to have epoch time across the csv data files	
var parseTime = d3.time.format("%H:%M:%S").parse;

var bisectTime = d3.bisector(function(d) { return d.time; }).left;

//Scales
var xScale = d3.time.scale()
    .range([0, width]),

    xScaleBrush = d3.time.scale()
    .range([0, width]); // Duplicate xScale for brushing ref later

var yScale = d3.scale.linear()
    .range([height, 0]);
	
//Category 10 colors
//var colors = d3.scale.category10();	
//Axis
var xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom"),

    xAxisBrush = d3.svg.axis() // xAxis for brush slider
    .scale(xScaleBrush)
    .orient("bottom");    

var yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("left");  

var line = d3.svg.line()
    .interpolate("basis")
    .x(function(d) {return xScale(d.time); })
    .y(function(d) { return yScale(d.value); })
    .defined(function(d) { return d.value; });  // Hiding line value defaults of 0 for missing data	
	
var maxY; // Defined later to update yAxis
var svg = {},arrColors = {},display = {},issue = {};
//List of Plots
var myPlots = ["disk","nw","resources"];
d3.select('body').selectAll('div').data(myPlots).enter().append('div').attr('id',function(d){return d;})
myPlots.forEach(function(plot){
	
	svg[plot] = d3.select("#"+plot).append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom) 
		.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");	
	//Category 10 colors for this plot
	arrColors[plot] = d3.scale.category10();		
	// Create invisible rect for mouse tracking
	svg[plot].append("rect")
		.attr("width", width)
		.attr("height", height)                                    
		.attr("x", 0) 
		.attr("y", 0)
		.attr("id", "mouse-tracker")
		.style("fill", "white"); 
	//append clip path for lines plotted, hiding those part out of bounds
	svg[plot].append("defs")
		.append("clipPath") 
		.attr("id", "clip")
		.append("rect")
		.attr("width", width)
		.attr("height", height); 
	//Data Processing
	d3.csv("p_"+ plot +".csv", function(error, data) { 
			if(error) console.log("ERROR:"+error);
			arrColors[plot].domain(d3.keys(data[0]).filter(function(key) { // Set the domain of the color ordinal scale to be all the csv headers except "time", matching a color to an issue
				return key !== "time"; 
			}));
		if(plot==="resources"){
			
		data.forEach(function(d) { // Make every date in the csv data a javascript date object format
			d.time = parseTime(d.time);
		  });
		}else{
			data.forEach(function(d) { // Make every date in the csv data a javascript date object format
			d.time = d.time*1000;
		  });
		}
		/*Preferably 'Epoch time for all of them'
		data.forEach(function(d) { // Make every date in the csv data a javascript date object format
			d.time = parseDate(d.time);
		});
		*/
		display[plot] = arrColors[plot].domain().map(function(name) { // Nest the data into an array of objects with new keys

			return {
			  name: name, // "name": the csv headers except date
			  values: data.map(function(d) { // "values": which has an array of the dates and ratings
					return {
					  time: d.time, 
					  value: parseFloat(d[name])
					};
				}),
			  visible: true 
			};
		});
		
		xScale.domain(d3.extent(data, function(d) { return d.time; })); // extent = highest and lowest points, domain is data, range is bouding box
		yScale.domain([0, findMaxY(display[plot])]);//d3.max later
		
		
		
		// draw line graph
	  svg[plot].append("g")
		  .attr("class", "x axis")
		  .attr("transform", "translate(0," + height + ")")
		  .call(xAxis);

	  svg[plot].append("g")
		  .attr("class", "y axis")
		  .call(yAxis)
		  /*.append("text")
		  .attr("transform", "rotate(-90)")
		  .attr("y", 6)
		  .attr("x", -10)
		  .attr("dy", ".71em")
		  .style("text-anchor", "end")
		  .text("Values");//<--*/

	  issue[plot] = svg[plot].selectAll(".issue")//<--
		  .data(display[plot]) // Select nested data and append to new svg group elements
		  .enter().append("g")
		  .attr("class", "issue");   

	  issue[plot].append("path")
		  .attr("class", "line")
		  .style("pointer-events", "none") // Stop line interferring with cursor
		  .attr("id", function(d) {
			return "line-" + d.name.replace(" ", "").replace("/", ""); // Give line id of line-(insert issue name, with any spaces replaced with no spaces)
		  })
		  .attr("d", function(d) { 
		  //console.log(d);
			return d.visible ? line(d.values) : null; // If array key "visible" = true then draw line, if not then don't 
		  })
		  .attr("clip-path", "url(#clip)")//use clip path to make irrelevant part invisible
		  .style("stroke", function(d) { return arrColors[plot](d.name); });
		  
	  // draw legend
	  var legendSpace = 450 / display[plot].length; // 450/number of issues (ex. 40)    

	  issue[plot].append("rect")
		  .attr("width", 10)
		  .attr("height", 10)                                    
		  .attr("x", width + (margin.right/3) - 15) 
		  .attr("y", function (d, i) { return (legendSpace)+i*(legendSpace) - 8; })  // spacing
		  .attr("fill",function(d) {
			return d.visible ? arrColors[plot](d.name) : "#F1F1F2"; // If array key "visible" = true then color rect, if not then make it grey 
		  })
		  .attr("class", "legend-box")

		  .on("click", function(d){ // On click make d.visible 
			d.visible = !d.visible; // If array key for this data selection is "visible" = true then make it false, if false then make it true

			maxY = findMaxY(display[plot]); // Find max Y rating value categories data with "visible"; true
			yScale.domain([0,maxY]); // Redefine yAxis domain based on highest y value of categories data with "visible"; true
			svg[plot].select(".y.axis")
			  .transition()
			  .call(yAxis);   
//console.log(display[plot]);
			issue[plot].select("path")
			 .transition()
			 .attr("d", function(d){
				 console.log(d);
				 if(d.visible){console.log(d.values);return line(d.values)}else{console.log(d.visible);}//return null;}
				//return d.visible ? console.log(d.values);line( d.values ) : console.log(d.visible);null; // If d.visible is true then draw line for this d selection
			  })

			issue[plot].select("rect")
			  .transition()
			  .attr("fill", function(d) {
			  return d.visible ? arrColors[plot](d.name) : "#F1F1F2";
			});
		  })

		  .on("mouseover", function(d){

			d3.select(this)
			  .transition()
			  .attr("fill", function(d) { return arrColors[plot](d.name); });

			d3.select("#line-" + d.name.replace(" ", "").replace("/", ""))
			  .transition()
			  .style("stroke-width", 2.5);  
		  })

		  .on("mouseout", function(d){

			d3.select(this)
			  .transition()
			  .attr("fill", function(d) {
			  return d.visible ? arrColors[plot](d.name) : "#F1F1F2";});

			d3.select("#line-" + d.name.replace(" ", "").replace("/", ""))
			  .transition()
			  .style("stroke-width", 1.5);
		  })
		  
	  issue[plot].append("text")
		  .attr("x", width + (margin.right/3)) 
		  .attr("y", function (d, i) { return (legendSpace)+i*(legendSpace); })  // (return (11.25/2 =) 5.625) + i * (5.625) 
		  .text(function(d) { return d.name; }); 

	  


	});
});
function retValues(data){ return data.values;}
  
function findMaxY(data){  // Define function "findMaxY"
	var maxYValues = data.map(function(d) { 
	  if (d.visible){
		return d3.max(d.values, function(t) { // Return max rating value
		  return t.value; })
	  }
	});
	return d3.max(maxYValues);
}