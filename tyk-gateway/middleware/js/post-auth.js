var postAuthMiddleware = new TykJS.TykMiddleware.NewMiddleware({});

postAuthMiddleware.NewProcessRequest(function(request, session) {
    if ((request.Headers["Upstream-Authorization"]) && (request.Headers["Upstream-Authorization"].length > 0)) {
        request.SetHeaders["Authorization"] = request.Headers["Upstream-Authorization"][0];
    } else {
        request.DeleteHeaders.push("Authorization");
    }
    request.DeleteHeaders.push("Upstream-Authorization");

    return postAuthMiddleware.ReturnData(request, {})
});