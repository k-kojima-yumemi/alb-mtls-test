export const handler = async (event, context) => {
    const replaced = {
        ...event,
        requestContext: {
            ...event.requestContext,
            elb: {
                ...event.requestContext.elb,
                targetGroupArn: "[HIDDEN]"
            }
        }
    }
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello from Lambda!",
            event: replaced,
        }),
        headers: {
            'Content-Type': 'application/json',
        },
    };
};
