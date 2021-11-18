const fs = require('fs');
let fn = process.argv[2];
let jsonData = JSON.parse(fs.readFileSync(process.argv[3]));

let regexp = /(\u0590|\u0591|\u0592|\u0593|\u0594|\u0595|\u0596|\u0597|\u0598|\u0599|\u059A|\u059B|\u059C|\u059D|\u059E|\u059F|\u05A0|\u05A1|\u05A2|\u05A3|\u05A4|\u05A5|\u05A6|\u05A7|\u05A8|\u05A9|\u05AA|\u05AB|\u05AC|\u05AD|\u05AE|\u05AF|\u05B0|\u05B1|\u05B2|\u05B3|\u05B4|\u05B5|\u05B6|\u05B7|\u05B8|\u05B9|\u05BA|\u05BB|\u05BC|\u05BD|\u05BE|\u05BF|\u05C0|\u05C1|\u05C2|\u05C3|\u05C4|\u05C5|\u05C6|\u05C7|\u05C8|\u05C9|\u05CA|\u05CB|\u05CC|\u05CD|\u05CE|\u05CF)/g
let superscript = / (\u00B9|\u00B2|\u00B3|\u2070|\u2071|\u2072|\u2073|\u2074|\u2075|\u2076|\u2077|\u2078|\u2079)/
let roman = / (I+)/

for (let x=0; x<jsonData.length; x++) {
	if (jsonData[x].heTitleVariants != undefined && jsonData[x].heTitleVariants[0] != undefined) {
		let data = jsonData[x].heTitleVariants[0] + "\t" + jsonData[x].text + "\n";
		fs.writeFileSync(fn, data, {flag: 'as+'});
		if (jsonData[x].heTitleVariants[0].match(regexp) || jsonData[x].heTitleVariants[0].match(superscript) || jsonData[x].heTitleVariants[0].match(roman)){
			let stripped = jsonData[x].heTitleVariants[0].replace(regexp, "").replace(superscript, "").replace(roman, "");
			stripped = stripped + "\t" + jsonData[x].text + "\n";
			fs.writeFileSync(fn, stripped, {flag: 'as+'});
		}
	} else {
		console.error("!!!!!" + jsonData[x]);
	}
	
}
if (jsonData[jsonData.length-1].next != null) {
	console.log(jsonData[jsonData.length-1].next)
}
