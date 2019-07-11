var fs = require('fs');
let gematria = require(process.argv[3]);
let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));

console.log("<title>" + jsonData.heSectionRef + "</title>");
for (let x=0; x<jsonData.he.length; x++) {
	if (jsonData.he[x] != "" ) {
		console.log("<h2>פרק " + gematria(x+1) + "</h2>");
	}
	for (let i=0; i<jsonData.he[x].length; i++) {
		var perek = gematria(i+1)
		var content = jsonData.he[x][i]
		console.log('<div class="mishnah"><span class="mishnahh">{'  + perek + '} </span>' + content + "</div>");
	}
}
