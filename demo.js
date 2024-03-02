const mqtt = require('mqtt');
const fs = require('fs');

const client = mqtt.connect('mqtt://127.0.0.1:8883', {
  
  key:  fs.readFileSync('./broker/export/client.key'),
  cert: fs.readFileSync('./broker/export/client.pem'),
  username: 'YourClientName',
  password: 'admin',
  protocol: 'mqtt',
  clientId: 'client_demo',
  rejectUnauthorized: false

})

console.log('Connecting to mqtt broker ' + client.reconnect());

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