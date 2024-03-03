const mqtt = require('mqtt');
const fs = require('fs');

const client = mqtt.connect('mqtt://dev.caracal.com:8883', {
  
  key:  fs.readFileSync('./certs/default_client.key'),
  cert: fs.readFileSync('./certs/default_client.crt'),
  ca:  fs.readFileSync('./certs/ca.crt'),
  username: 'default_client',
  password: 'admin',
  protocol: 'mqtts',
  clientId: 'client_demo',
  rejectUnauthorized: true

})

client.on('error', (err) => { console.log('Error from mqtt broker: ', err) });
client.on('disconnect', () => { console.log('Disconnected from mqtt broker') });

client.on('connect', () => {
  console.log('Connected to mqtt broker');
  client.subscribe('demotopic');
  client.publish('demotopic', 'Hello mqtt');
});

client.on('message', (topic, message) => {
  console.log(`Received message: ${message.toString()}`);
  client.end();
});