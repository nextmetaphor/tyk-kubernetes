var preAuthMiddleware = new TykJS.TykMiddleware.NewMiddleware({});

preAuthMiddleware.NewProcessRequest(function(request, session) {
    if ((request.Headers["Authorization"]) && (request.Headers["Authorization"].length > 0)) {
        request.SetHeaders["Upstream-Authorization"] = request.Headers["Authorization"][0];
    }
    if ((request.Headers["Gateway-Authorization"]) && (request.Headers["Gateway-Authorization"].length > 0)) {
        request.SetHeaders["Authorization"] = request.Headers["Gateway-Authorization"][0];
    }
    request.DeleteHeaders.push("Gateway-Authorization");

    return preAuthMiddleware.ReturnData(request, {})
});
