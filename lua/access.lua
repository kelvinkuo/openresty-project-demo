-- created by kelvinkuo
-- date: 2019-03-04

local url = ngx.var.host .. ngx.var.request_uri  -- host+path+query
local uri = ngx.var.host .. ngx.var.uri          -- host+path
local complete_uri = uri                         -- scheme+host+path
-- add schema to uri
local is_https = ngx.req.get_headers()["XZ-HTTPS-ENABLED"]
if is_https == "0" then
    complete_uri = "http://" .. complete_uri
elseif is_https == "1" then
    complete_uri = "https://" .. complete_uri
else
    complete_uri = ngx.var.scheme .. "://" .. complete_uri
end

local complete_url = "https://" .. url
if string.len(ngx.var.request_uri) > 1500 then -- fix nginx reponse header too long
  complete_url = "https://" .. ngx.var.host
end
complete_url = ngx.escape_uri(complete_url)
-- ipStr is remote_addr and forwarded_for
local ipStr = ngx.var.remote_addr
local x_forward_for = ngx.var.http_x_forwarded_for
if x_forward_for ~= nil then
    ipStr = ipStr .. "," .. x_forward_for
end

ngx.say("你好")

-- traceId
local hostname = ngx.var.hostname
local headers = ngx.req.get_headers()
local workerid = ngx.worker.id()
local ipcheck_trace = ""
if not headers["x-trace-id"] then
    math.randomseed(tonumber(tostring(ngx.now()*1000):reverse():sub(1,9)))
    local randvar = string.format("%.0f",math.random(1000000000000000000,99223372036854775807))
    local onlyStringTrace = tostring(hostname .. workerid .. ngx.now()*1000 .. randvar)
    local traceid = tostring(ngx.md5(onlyStringTrace)):sub(1, 20)
    ngx.req.set_header("x-trace-id", traceid)
    ipcheck_trace = traceid:sub(1,10)
    local onlyStringSpan = tostring(hostname .. workerid .. ngx.now()*1000 .. randvar .. workerid) -- diffrent from trace
    local spanid = tostring(ngx.md5(onlyStringSpan)):sub(1, 16)
    ngx.req.set_header("x-span-id", spanid)

    -- ngx.log(ngx.INFO, "x-trace-id=" .. traceid)
    -- ngx.log(ngx.INFO, "x-span-id=" .. spanid)
    -- ngx.log(ngx.INFO, "ipcheck_trace=" .. ipcheck_trace)
end


