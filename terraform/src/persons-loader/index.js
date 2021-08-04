const faker = require("faker");
const AWS = require("aws-sdk");

exports.handler = async (event) => {
  const batchSize = event.batchSize;
  let persons = [];
  const tableName = process.env.TABLE_NAME;
  const docClient = new AWS.DynamoDB.DocumentClient();

  for (let step = 0; step < batchSize; step++) {
    const person = {
      lastname: faker.name.lastName(),
      firstname: faker.name.firstName(),
      gender: faker.name.gender(),
      title: faker.name.title(),
      jobDescriptor: faker.name.jobDescriptor(),
      jobArea: faker.name.jobArea(),
      jobType: faker.name.jobType(),
    };

    const params = {
      TableName: tableName,
      Item: {
        pk: String(Math.random()),
        person: person,
      },
    };

    await docClient
      .put(params, function (err, data) {
        if (err) {
          const response = {
            statusCode: 400,
            body: err,
          };
          return response;
        } else {
          console.log("Added item:", JSON.stringify(data, null, 2));
        }
      })
      .promise();

    persons = [...persons, person];
  }

  const response = {
    statusCode: 200,
    body: persons,
  };
  return response;
};
