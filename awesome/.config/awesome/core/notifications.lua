local naughty = require("naughty")

local utils = require("utils")

local function single_line(value)
    return tostring(value or ""):gsub("%s+", " ")
end

naughty.config.notify_callback = function(args)
    if not args.skip_log then
        utils.log(
            string.format(
                "[notification] app=%s title=%s text=%s",
                single_line(args.appname),
                single_line(args.title),
                single_line(args.text)
            ),
            "info"
        )
    end

    return args
end
