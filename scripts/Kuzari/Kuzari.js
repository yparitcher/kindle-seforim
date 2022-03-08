var fs = require('fs');
let gematria = require(process.argv[3]);
let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));

console.log("<title>" + jsonData.heSectionRef + "</title>");
for (let x=0; x<jsonData.he.length; x++) {
	if (jsonData.he[x] != "" ) {
		var mamar = gematria(x+1)
		console.log("<h2>" + "מאמר " + mamar + "</h2>");
	}
	for (let i=0; i<jsonData.he[x].length; i++) {
		var seif = gematria(i+1)
		console.log('<div class="statement">' + jsonData.he[x][i] + "</div>");
	}
}
