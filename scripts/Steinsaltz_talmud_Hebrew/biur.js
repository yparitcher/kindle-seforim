var fs = require('fs');

let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));

for (let x=0; x<jsonData[2].contents[0].contents[7].contents[38].contents.length; x++) {
	for (let i=0; i<jsonData[2].contents[0].contents[7].contents[38].contents[x].contents.length; i++) {
		console.log(jsonData[2].contents[0].contents[7].contents[38].contents[x].contents[i].title);
	}
}
