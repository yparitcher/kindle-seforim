var fs = require('fs');

let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));

for (let x=0; x<6; x++) {
	for (let i=0; i<jsonData[2].contents[0].contents[x].contents.length; i++) {
		console.log(jsonData[2].contents[0].contents[x].contents[i].title);
	}
}
