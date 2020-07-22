var fs = require('fs');
var path = require('path');
let gematria = require(process.argv[3]);
let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));
let x = parseInt(path.basename(process.argv[2], ".json"))

	if (jsonData.alts[0] != undefined){
		console.log("<h2>" + jsonData.alts[0]["he"][0] + "</h2>");
	}
	for (let i=0; i<jsonData.he.length; i++) {
		let sn = i+1
		var seif = gematria(sn)
		var content = jsonData.he[i]
		if (i==0) {
			var index = content.indexOf('</b>');
			if (index==-1){index=0;}else{index+=4;}
			console.log( "<h3>" + gematria(x) + ") " + content.substring(0, index ) + "</h3>");
			console.log('<div class="seif"><span class="seifh">'  + seif + ') </span>' + content.substring(index) + "</div>");
		} else {
			console.log('<div class="seif"><span class="seifh">'  + seif + ') </span>' + content + "</div>");
		}
		for (let y=0; y<jsonData.commentary.length; y++) {
			let ref = "Shulchan Arukh, Orach Chayim " + x + ":" + sn
			if (jsonData.commentary[y].index_title == "Mishnah Berurah" && jsonData.commentary[y].anchorRef == ref) {
				console.log('<div class="pirush">' + jsonData.commentary[y].he + "</div>");
			}
		}
	}

