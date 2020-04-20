var fs = require('fs');

let jsonData = JSON.parse(fs.readFileSync(process.argv[2]));

for (let x=0; x<jsonData[0].contents[4].contents[7].contents[0].contents.length; x++) {
	console.log(jsonData[0].contents[4].contents[7].contents[0].contents[x].title);
}
