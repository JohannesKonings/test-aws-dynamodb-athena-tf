const index = require("./index");

test("user data loader", async () => {
  const event = { batchSize: 5 };
  const lamda_return = await index.handler(event);
  console.log("return", lamda_return);
  //expect(sum(1, 2)).toBe(3);
});
