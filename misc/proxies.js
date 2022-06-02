const request = require('request')

var started = false;
var valid_proxies = [];

function proxyCheck(args, proxy, res){
    if(started  || res.elapsedTime > args.uptime || (!(args.proxylen == 'false') && valid_proxies.length >= args.proxylen)) return;

    console.log(`${proxy} :: ${res.elapsedTime} :: ${valid_proxies.length}`);
    valid_proxies.push(proxy);
}

function checkProxy(args, proxy){
    request({
        url: args.precheck,
        proxy: "http://" + proxy,
        time: true,
        headers: {
            'Connection': 'keep-alive',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            'Upgrade-Insecure-Requests': 1,
            'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0",
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
            'Accept-Language': 'en-US,en;q=0.9'
        }
    }, (err, res, body) => {
        //console.log(err);
	if(!err) proxyCheck(args, proxy, res);
    });
}

function prepare(args){
    started = true;
    console.log(`\nValid proxies: ${valid_proxies.length}`);

    return require('./prepare.js')(args, valid_proxies);
}

function start(args){
    request({
        url: args.proxy,
        headers: {
            'Connection': 'keep-alive',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            'Upgrade-Insecure-Requests': 1,
            'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0",
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
            'Accept-Language': 'en-US,en;q=0.9'
        }
    }, (err, res, body) => {
        let merc = body.replace(/\r/g, '').split("\n");
        console.log(merc.length);
	if(merc.length < 1) return start(args);
	let max = args.proxylen == 'false' ? merc.length - 1 : 1500 + args.proxylen;

        for(let i = 0; i < max; i++){
            let pP = merc[Math.floor(Math.random() * (merc.length - 1))];
            merc.splice(merc.indexOf(pP), 1);

            checkProxy(args, pP);
        }
    });
    setTimeout(() => {
        return prepare(args);
    }, (args.pool * 1000));
}


module.exports = start;
