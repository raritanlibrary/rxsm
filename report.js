import { execSync } from 'child_process';
import * as fs from 'fs';
//import puppeteer from 'puppeteer';

execSync('bash ./report.bash', {stdio: 'inherit'});
const www = fs.readdirSync('tmp/wwwStat/');
const dir = new Date().toISOString().replace(/T.+/, '').replace(/-/g, '')
fs.mkdirSync(`out/${dir}`)

//const browser = await puppeteer.launch();
//const page = await browser.newPage();
for (const file of www) {
    if (file.endsWith('.html')) {
        let path = `tmp/wwwStat/${file}`;
        let data = fs.readFileSync(path).toString();
        data = data.replace(/src="\//g, `src="`);
        fs.writeFileSync(path, data);
        //await page.setContent(data, {waitUntil: 'networkidle0'});
        //await page.pdf({path: `out/${dir}/${file.slice(8, -5)}.pdf`});
    }
};

//await browser.close();
execSync(`mv tmp/wwwStat/* out/${dir} && rm -rf tmp/*`, {stdio: 'inherit'});