export const handler = async (event) => {
    console.log("Received event:");
    console.log(JSON.stringify(event, null, 2));

    for (const record of event.Records) {
        const message = record.body;
        const sourceIsDiscord = record.eventSourceARN?.includes("beanflow-discord-queue");

        console.log("Message:", message);

        if (sourceIsDiscord) {
            const response = await fetch(process.env.DISCORD_WEBHOOK_URL, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    content: message
                })
            });

            if (!response.ok) {
                const responseBody = await response.text();
                throw new Error(`Discord webhook failed (${response.status}): ${responseBody}`);
            }
        }
    }

    return {
        statusCode: 200
    };
};