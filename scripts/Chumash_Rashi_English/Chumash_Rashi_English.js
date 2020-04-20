var fs = require('fs');
let gematria = require(process.argv[4]);
let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));
let commentaryData = JSON.parse(fs.readFileSync(process.argv[3]));
let directory = process.argv[5];
let count = fs.readFileSync(process.argv[6]);
let file = null;

for (let x=0; x<jsonData.he.length; x++) {
	if (jsonData.he[x] != "") {
		for (let i=0; i<jsonData.he[x].length; i++) {
			if (jsonData.he[x][i] != "") {
				if (jsonData.alts[x] != undefined && jsonData.alts[x][i] != undefined && jsonData.alts[x][i].whole ){
					count = (parseInt(count) + 1).toString();
					fs.writeFileSync(process.argv[6], count);
					file = directory + count.padStart(2, "0") + "_" + jsonData.alts[x][i]["en"][0] + ".html";
					fs.writeFileSync(file, "<title>" + jsonData.alts[x][i]["he"][0] + "</title>\n");
					fs.appendFileSync(file, "<h2>" + jsonData.alts[x][i]["he"][0] + "</h2>\n");
					fs.appendFileSync(file, "<h3>" + "פרק " + gematria(x+1) + "</h3>\n");
				} else if (jsonData.alts[x] != undefined && jsonData.alts[x][i] != undefined){
					fs.appendFileSync(file, "<h2>" + jsonData.alts[x][i]["he"][0] + "</h2>\n");
				} else if (i == 0){
					fs.appendFileSync(file, "<h3>" + "פרק " + gematria(x+1) + "</h3>\n");
				}
				fs.appendFileSync(file, '<p class="chumash"><b>' + gematria(i+1) + " </b>" + jsonData.he[x][i] + "</p>\n");
				if (jsonData.text[x] != "" && jsonData.text[x][i] != undefined) {
					fs.appendFileSync(file, '<p class="chumashE">' + jsonData.text[x][i] + "</p>\n");
				}
				if (commentaryData.he[x]!= undefined && commentaryData.he[x][i] != 0 && commentaryData.he[x][i] != undefined ) {
					for (let y=0; y<commentaryData.he[x][i].length ; y++) {
						fs.appendFileSync(file, '<p class="rashi">' + commentaryData.he[x][i][y] + "</p>\n");
						if (commentaryData.text[x] != undefined && commentaryData.text[x][i] != undefined && commentaryData.text[x][i][y] != undefined) {
							fs.appendFileSync(file, '<p class="rashiE">' + commentaryData.text[x][i][y] + "</p>\n");
						}
					}
				}
			}
		}
	}
}
