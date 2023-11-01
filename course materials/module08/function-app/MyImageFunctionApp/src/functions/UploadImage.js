const azure = require('azure-storage');

module.exports = async function (context, req) {
    const blobService = azure.createBlobService();
    const containerName = 'images';

    // Ensure the container exists
    blobService.createContainerIfNotExists(containerName, { publicAccessLevel: 'blob' }, (error, result, response) => {
        if (error) {
            context.res = { status: 500, body: "Unable to create container" };
            context.done();
        }
    });

    // Assuming image data comes in as base64
    const matches = req.body.image.match(/^data:([A-Za-z-+/]+);base64,(.+)$/);
    const type = matches[1];
    const buffer = new Buffer.from(matches[2], 'base64');

    // Generate a unique name for the blob
    const blobName = `${new Date().getTime()}.${type.split('/')[1]}`;

    blobService.createBlockBlobFromText(containerName, blobName, buffer, (error, result, response) => {
        if (error) {
            context.res = { status: 500, body: "Unable to upload image" };
        } else {
            context.res = { status: 200, body: `Image uploaded with name: ${blobName}` };
        }
        context.done();
    });
};

module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    if (req.method === "POST") {
        // Your logic here for POST
        context.res = {
            // status: 200, /* Defaults to 200 */
            body: "Your POST request has been processed."
        };
    } else {
        context.res = {
            status: 400,
            body: "Only POST requests are allowed."
        };
    }
};
