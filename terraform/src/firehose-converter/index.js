"use strict";
console.log("Loading function");

exports.handler = (event, context, callback) => {
  /* Process the list of records and transform them */
  const output = event.records.map((record) => {
    let entry = Buffer.from(record.data, "base64").toString("utf8");
    let result = entry + "\n";
    const payload = Buffer.from(result, "utf8").toString("base64");

    return {
      recordId: record.recordId,
      result: "Ok",
      data: payload,
    };
  });
  console.log(`Processing completed.  Successful records ${output.length}.`);
  callback(null, { records: output });
};
