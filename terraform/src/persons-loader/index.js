const faker = require("faker");

exports.handler = async (event) => {
  const batchSize = event.batchSize;
  let persons = [];

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
    persons = [...persons, person];
  }

  const response = {
    statusCode: 200,
    body: persons,
  };
  return response;
};
