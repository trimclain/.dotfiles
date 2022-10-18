-- This is the Bracey Liveserver plugin config
-- Most of this is left to default

vim.g.bracey_browser_command = 0                        -- string command to laucnch the browser, default (0) is xdg-open
vim.g.bracey_auto_start_browser = 1                     -- (false: 0, true: 1) whether or not to start the browser (by running g:bracey_browser_command) when bracey is started
vim.g.bracey_refresh_on_save = 0                        -- (false: 0, true: 1) whether or not to reload the current web page whenever its corresponding buffer is written
vim.g.bracey_eval_on_save = 1                           -- (false: 0, true: 1) whether or not to evaluate a buffer containing javascript when it is saved
vim.g.bracey_auto_start_server = 1                      -- (false: 0, true: 1) whether or not to start the node server when :Bracey is run
vim.g.bracey_server_allow_remote_connections = 0        -- (false: 0, true: 1) whether or not to allow other machines on the network to connect to the node server's webpage.
                                                        -- This is useful if you want to view what changes will look like on other platforms at the same time
-- let g:bracey_server_port =                            -- default: random-ish number derived from vim's pid; (int) the port that the node server will serve files at and receive commands at
vim.g.bracey_server_path = 'http://127.0.0.1'           -- (string) address at which the node server will reside at (should start with 'http://' and not include port)
vim.g.bracey_server_log = '/tmp/bracey_server_logfile'  -- (string) location to log the node servers output


-- HOW IT WORKS:
-- The architecture looks something like this:
-- +-----+--------+    +--------+     +---------+
-- | vim | python |    | nodejs |     | browser |
-- |     | plugin ---->| server |---->| client  |
-- |     |        |    |        |     |         |
-- +-----+--------+    +--------+     +---------+
--
-- - Vim uses python to launch and communicate with the nodejs server. All
--   relevant actions (cursor move, text change, buffer switch, etc.) are sent
--   to the node server.
--
-- - The nodejs web server sits at the heart of bracey. This server maintains
--   file state, serves assets, transforms documents, and forwards events.
--
-- - The browser client is created by transforming and injecting scripts into
--   the user's code. This client carries out actions on behalf of the nodejs
--   server.

-- When the server first starts up it waits for messages indicating the project's
-- root directory and current buffer. Once these are received it will begin
-- serving the current buffer along with any static assets.

-- To serve an HTML document it must first parse it into an AST, annotate the
-- elements, inject the client, and send the result to the web browser. Edits
-- from Vim will diffed against the existing AST to produce a (ideally) minimal
-- set of tree modifications to send to the client. Reducing the number of ops is
-- vital as any remounted element loses runtime state and too many remounts might
-- as well just be a page refresh.

-- Highlighting the element under the cursor is done through the AST's
-- line/column annotations. The HTML transformation step includes tagging each
-- element with a unique key. Once an AST node is selected a unique key is looked
-- up and sent to the client.
--
--
-- USAGE:
-- bracey won't do anything until it is explicitly called

-- :Bracey
-- this starts the bracey server and optionally opens your default web browser
-- to bracey's address. if you have an html file open as your current buffer,
-- it will be displayed and you may begin editing it live.

-- :BraceyStop
-- will shutdown the server and stop sending commands

-- :BraceyReload
-- force the current web page to be reloaded

-- :BraceyEval [args]
-- if argument(s) are given then evaluate them as javascript in the browser.
-- Otherwise, evaluate the entire buffer (regardless of its filetype).
