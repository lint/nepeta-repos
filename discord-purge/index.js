const request = require('request-promise-native');
const inquirer = require('inquirer');
const ProgressBar = require('progress');

const ENDPOINT = 'https://discordapp.com/api/v6/';
var headers = {};
let ignoreChannels = {};
let ignores = 0
let offset = 0

async function getMessages(type, target, user, offset) {
  return JSON.parse(await request({
    'url': ENDPOINT + type + 's/' + target + '/messages/search?author_id=' + user + '&include_nsfw=true&offset=' + offset,
    'headers': headers
  }));
}

async function removeMessage(channel_id, id) {
  if (ignoreChannels[channel_id])
    ignores++
  else
    try {
    await request({
      'method': 'DELETE',
      'url': ENDPOINT + 'channels/' + channel_id + '/messages/' + id,
      'headers': headers
    });
    } catch(e) {
      console.log("Failed to delete message "+id);
      console.log(e.error);
      offset++;
    }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function removeMessages(type, target, user){
  let bar;

  while (true) {
    let res = await getMessages(type, target, user, offset);
    if (res.hasOwnProperty('document_indexed') && ind == 0) {
      console.log('Not indexed yet. Retrying after 2 seconds.');
      await sleep(2000);
      continue;  
    }

    let messages = res.messages;

    if (!bar) { 
      bar = new ProgressBar(':bar :percent :current/:total eta: :eta s', { total: res.total_results });
    }

    if ((messages.length - ignores) == 0 || (res.total_results - ignores) == 0) {
      console.log('Done!');
      return;
    }
    
    messages = messages.map(x => {
      return x.reduce((acc, val) => {
        if (val.hit) return val;
        else return acc;
      });
    });

    for (var i = 0; i < messages.length; i++) {
      await removeMessage(messages[i].channel_id, messages[i].id);
      await sleep(200);
      bar.tick();
    }
  }
}

async function userInput() {
  var answers = await inquirer.prompt([{
    'type': 'input',
    'name': 'token',
    'message': 'Token'
  }]);

  headers = {
    'Authorization': answers.token
  };

  let user = JSON.parse(await request({
    'url': ENDPOINT + '/users/@me',
    'headers': headers
  }));

  console.log('Logged in as: ' + user.username + '#' + user.discriminator);

  answers = await inquirer.prompt([
    {
      'type': 'list',
      'name': 'type',
      'message': 'What would you like to delete?',
      'choices': [{
        'value': 'guild',
        'name': 'Guild messages'
      },
      {
        'value': 'channel',
        'name': 'DMs'
      }]
    }
  ]);

  if (answers.type == 'guild') {
    let r = await inquirer.prompt([{
      'type': 'input',
      'name': 'list',
      'message': 'Ignored Channels (seperate with commas; leave blank if none)'
    }]);

    let u = {};
    if (!!r.list && r.list !== '') {
      let l = r.list.split(',')
      for (const i in l)
        u[l[i].trim()] = true
    }
    ignoreChannels = u;

    delete r
  }

  let type = answers.type;

  let targets = JSON.parse(await request({
    'url': ENDPOINT + '/users/@me/' + type + 's',
    'headers': headers
  }));

  targets = targets.map(x => {
    x.value = x.id;

    if (type == 'channel') {
      x.name = x.recipients.reduce(
        (acc, y, i) => (i != 0 ? acc + ', ' : '') + y.username + '#' + y.discriminator,
      "");
    }

    return x;
  });

  answers = await inquirer.prompt([
    {
      'type': 'list',
      'name': 'target',
      'message': type,
      'choices': targets
    }
  ]);

  let target = answers.target;
  answers = await inquirer.prompt([
    {
      'type': 'confirm',
      'name': 'confirm',
      'message': 'Are you sure? This will delete all of your messages.',
      'default': false
    }
  ]);

  if (answers.confirm) {
    await removeMessages(type, target, user.id);
  }
}

userInput();
