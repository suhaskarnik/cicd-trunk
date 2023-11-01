exports.handler = async(event)=>{
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda! This is v2 of the app'),
    };
    return response;
};