const lambdaLocal = require('lambda-local');
const handler = require('./app.js'); // Replace with the path to your Lambda function code

const event = {
  // You can provide an event object that your Lambda function expects
  // For a simple "Hello World" function, you can use an empty object or customize it as needed
};

const context = {
  // You can provide a context object if your Lambda function relies on it
  // For a basic test, you can use an empty object
};

const callback = (err, data) => {
  if (err) {
    console.error('Error:', err);
  } else {
    console.log('Success:', data);
  }
};

lambdaLocal.execute({
  event,
  lambdaFunc: handler, 
  lambdaHandler: "handler",
  callback,
  context,
  timeoutMs: 3000, 
});
