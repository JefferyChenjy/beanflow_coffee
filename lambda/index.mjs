export const handler = async (event) => {
    console.log("Received event:");
    console.log(JSON.stringify(event, null, 2));

    for (const record of event.Records) {
        console.log("Message:", record.body);
    }

    return {
        statusCode: 200
    };
};